#!/usr/bin/python3
#
# Original installation script written by Selva Samuel
#
# Modified by Chris Timperley (chris@christimperley.co.uk)
from Queue import Queue

from sets import Set
from urlparse import urlparse

import os
import requests
import subprocess
import xml.etree.ElementTree as XmlTree
import yaml

catkin_ws_dir = os.environ['catkin_ws_location']
print(catkin_ws_dir)
pkg_src_root_dir = catkin_ws_dir + '/src'
install_dir_name = 'install_isolated'
install_log_file_name = 'package_install_log.txt'

subprocess.check_call(['rm', '-rf', install_log_file_name])

subprocess.check_call(['rm', '-rf', catkin_ws_dir])
subprocess.check_call(['mkdir', '-p', pkg_src_root_dir])

subprocess.check_call(['catkin_init_workspace'], cwd=pkg_src_root_dir)

# Download the source code of sophus
subprocess.check_call(['git', 'clone', '-b', 'indigo', 'https://github.com/stonier/sophus.git'], cwd=pkg_src_root_dir)

# I have assumed two things here:
# 1. The username is turtlebot.
# 2. The catkin workspace for building the ROS packages was created at /home/turtlebot/turtlebot_src/ros_catkin_ws
ros_src_path = '/home/' + os.environ['USER'] + '/turtlebot_src/ros_catkin_ws/build_isolated'

installed_dependencies = Set(os.listdir(ros_src_path))
installed_dependencies.remove('.built_by')
installed_dependencies.remove('catkin_make_isolated.cache')
installed_dependencies.add('python-rospkg')
installed_dependencies.add('python-catkin-pkg')
installed_dependencies.add('avahi-daemon')
installed_dependencies.add('avahi-utils')
installed_dependencies.add('redis-server')
installed_dependencies.add('python-crypto')
installed_dependencies.add('python-yaml')
installed_dependencies.add('python-pymongo')
installed_dependencies.add('libavahi-core-dev')
installed_dependencies.add('libavahi-client-dev')
installed_dependencies.add('python-bson')
installed_dependencies.add('python-twisted-core')
installed_dependencies.add('python-imaging')
installed_dependencies.add('python-pep8')
installed_dependencies.add('python-mock')
installed_dependencies.add('python-coverage')
installed_dependencies.add('boost')
installed_dependencies.add('pyqt4-dev-tools')
installed_dependencies.add('ffmpeg')
installed_dependencies.add('libssl-dev')
installed_dependencies.add('curl')
installed_dependencies.add('gtest')
installed_dependencies.add('mongodb-dev')
installed_dependencies.add('libqt4-dev')
installed_dependencies.add('yaml-cpp')
installed_dependencies.add('tinyxml')
installed_dependencies.add('libqt4')
installed_dependencies.add('eigen')
installed_dependencies.add('netpbm')
installed_dependencies.add('sdl-image')
installed_dependencies.add('python-websocket')
installed_dependencies.add('sophus')
installed_dependencies.add('libusb-dev')
installed_dependencies.add('libusb-1.0-dev')
installed_dependencies.add('python-cwiid')
installed_dependencies.add('python-numpy')
installed_dependencies.add('libspnav-dev')
installed_dependencies.add('bluez')
installed_dependencies.add('spacenavd')
installed_dependencies.add('joystick')
installed_dependencies.add('python-bluez')
installed_dependencies.add('libx11-dev')
installed_dependencies.add('libfreenect')
installed_dependencies.add('log4cxx')
installed_dependencies.add('libsensors4-dev')
installed_dependencies.add('cppunit')
installed_dependencies.add('libftdi-dev')
installed_dependencies.add('ftdi-eeprom')
installed_dependencies.add('libopenni2-dev')
installed_dependencies.add('libopenni-dev')
installed_dependencies.add('git')
installed_dependencies.add('libudev-dev')

rocon_rosinstall = requests.get('https://raw.githubusercontent.com/robotics-in-concert/rocon/release/indigo/rocon.rosinstall').text
kobuki_rosinstall = requests.get('https://raw.github.com/yujinrobot/yujin_tools/master/rosinstalls/indigo/kobuki.rosinstall').text
turtlebot_rosinstall = requests.get('https://raw.github.com/yujinrobot/yujin_tools/master/rosinstalls/indigo/turtlebot.rosinstall').text
rosinstalls = [ rocon_rosinstall, kobuki_rosinstall, turtlebot_rosinstall ]

pkg_info = dict()
downloaded_repos = Set()
installed_repos = Set()
work_queue = Queue()
packages_added_to_work_queue = Set()

for rosinstall in rosinstalls:
	for element in yaml.load(rosinstall):
		pkg_name = element['git']['local-name']
		pkg_info[pkg_name] = { 'branch': element['git']['version'], 'uri': element['git']['uri'] }
		if pkg_name != 'rocon_rapps' and not pkg_name in packages_added_to_work_queue:
			packages_added_to_work_queue.add(pkg_name)
			work_queue.put(pkg_name)

work_queue.put('openni_launch')

while not work_queue.empty():
	pkg_name = work_queue.get()

	print '\nResolving dependencies for ' + pkg_name + '\n'
	print '\nNo. of packages in queue: ' + str(work_queue.qsize()) + '\n'

	if not pkg_name in installed_dependencies:
		if not pkg_info.has_key(pkg_name):
			print '\nLocating package source: ' + pkg_name + '\n'

			roslocate_output = subprocess.check_output(['roslocate', 'info', pkg_name])
			print roslocate_output

			for element in yaml.load(roslocate_output):
				pkg_info[pkg_name] = { 'branch': element['git']['version'], 'uri': element['git']['uri'] }
				if pkg_name == 'laptop_battery_monitor' or pkg_name == 'libsensors_monitor':
					# roslocate returns master for branch name but there is no branch named master in the repository.
					pkg_info[pkg_name]['branch'] = 'indigo'

		branch_name = pkg_info[pkg_name]['branch']
		uri = pkg_info[pkg_name]['uri']
		basename = os.path.basename(urlparse(uri).path)
		if not (branch_name, basename) in downloaded_repos:
			print '\nDownloading source for package: ' + pkg_name + '\n'
			subprocess.check_call(['git', 'clone', '-b', branch_name, uri], cwd=pkg_src_root_dir)
			downloaded_repos.add((branch_name, basename))

		pkg_src_dir = os.path.splitext(basename)[0]

		if pkg_info[pkg_name].has_key('dependencies'):
			external_dependencies = pkg_info[pkg_name]['dependencies']
			all_dependencies_present = True
			for dependency in external_dependencies:
				if not dependency in installed_dependencies:
					all_dependencies_present = False
		else:
			#print 'Dependencies for ' + pkg_name + '\n'
			all_dependencies = Set()
			provided_packages = Set()
			external_dependencies = Set()
			all_dependencies_present = True
			for root, dirs, files in os.walk(pkg_src_root_dir + '/' + pkg_src_dir):
				if 'package.xml' in files:
					provided_packages.add(os.path.basename(root))
					pkg_xml = XmlTree.parse(os.path.join(root, 'package.xml'))
					root_element = pkg_xml.getroot()

					for dependency in root_element.iter('build_tool_depend'):
						# The name of one of the packages(diagnostic_msgs) had a space after it.
						# The strip() function is used to trim the leading and trailing spaces.
						all_dependencies.add(dependency.text.strip())

					for dependency in root_element.iter('build_depend'):
						all_dependencies.add(dependency.text.strip())

					for dependency in root_element.iter('build_export_depend'):
						all_dependencies.add(dependency.text.strip())

					for dependency in root_element.iter('depend'):
						all_dependencies.add(dependency.text.strip())

					for dependency in root_element.iter('exec_depend'):
						all_dependencies.add(dependency.text.strip())

					for dependency in root_element.iter('test_depend'):
						all_dependencies.add(dependency.text.strip())

					for dependency in root_element.iter('doc_depend'):
						all_dependencies.add(dependency.text.strip())

					for dependency in root_element.iter('run_depend'):
						all_dependencies.add(dependency.text.strip())

			for dependency in all_dependencies:
				if not dependency in provided_packages and not dependency in installed_dependencies:
					external_dependencies.add(dependency)
					all_dependencies_present = False

			pkg_info[pkg_name]['dependencies'] = external_dependencies

		if all_dependencies_present:
			print '\nCan install ' + pkg_name + '\n'
			subprocess.check_call(['bash', '-c', 'echo -e \'Can install ' + pkg_name + '\' >> ' + install_log_file_name])

			installed_dependencies.add(pkg_name)
			for root, dirs, files in os.walk(pkg_src_root_dir + '/' + pkg_src_dir):
				if 'package.xml' in files:
					installed_dependencies.add(os.path.basename(root))
			installed_repos.add((branch_name, basename))
			pkg_info.pop(pkg_name, None)
		else:
			print '\nCan\'t install ' + pkg_name + ' because of missing dependencies\n'
			for dependency in external_dependencies:
				if not dependency in installed_dependencies:
					print '\t' + dependency

					if not dependency in packages_added_to_work_queue:
						packages_added_to_work_queue.add(dependency)
						work_queue.put(dependency)

			work_queue.put(pkg_name)

subprocess.check_call(['bash', '-c', 'catkin_make_isolated -DCMAKE_INSTALL_PREFIX=' + install_dir_name + ' --install'], cwd=catkin_ws_dir)
#subprocess.check_call(['bash', '-c', \
#					   'source ' + install_dir_name + \
#					   '/setup.bash && catkin_make_isolated -DCMAKE_INSTALL_PREFIX=' + \
#					   install_dir_name + ' --install'], cwd=catkin_ws_dir)

subprocess.check_call(['bash', '-c', 'echo -e \'' + str(installed_dependencies).replace('\'', '\'\\\'\'') + '\' > all_packages.txt'])
