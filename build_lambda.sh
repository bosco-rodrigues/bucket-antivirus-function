#!/usr/bin/env bash

# Upside Travel, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

lambda_output_file=/opt/app/build/lambda.zip

set -e

echo -ne "$(date +"%F-%T") - Updating packages \t => "
yum update --assumeyes >> build.log 2>&1 && \
 echo "Successful"

echo -ne "$(date +"%F-%T") - Installing additional system packages => "
yum install --assumeyes cpio python2-pip yum-utils zip https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Installing Python modules => "
pip install --no-cache-dir virtualenv >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Creating a new Python VirtualEnv => "
virtualenv env >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Activating new VirtualEnv => "
source env/bin/activate >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Installing Python dependencies in VirtualEnv => "
pip install --no-cache-dir -r requirements.txt >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Downloading rpm packages => "
pushd /tmp >> build.log 2>&1 && yumdownloader -x \*i686 --archlist=x86_64 clamav clamav-lib clamav-update json-c pcre2 >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Extracting clamav-0*.rpm => "
rpm2cpio clamav-0*.rpm | cpio -idmv >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Extracting clamav-lib*.rpm  => "
rpm2cpio clamav-lib*.rpm | cpio -idmv >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Extracting clamav-update*.rpm => "
rpm2cpio clamav-update*.rpm | cpio -idmv >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Extracting json-c*.rpm => "
rpm2cpio json-c*.rpm | cpio -idmv >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Extracting pcre*.rpm => "
rpm2cpio pcre*.rpm | cpio -idmv >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Creating directory:bin => "
popd >> build.log 2>&1 && mkdir -pv bin >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Copying binaries => "
cp -v /tmp/usr/bin/clamscan /tmp/usr/bin/freshclam /tmp/usr/lib64/* bin/. >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Writing freshclam.conf => "
echo "DatabaseMirror database.clamav.net" > bin/freshclam.conf >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Creating directory:build => "
mkdir -pv build  >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Packaging Lambda function => "
zip -r9 $lambda_output_file *.py >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Packaging ClamAV binaries => "
zip -r9 $lambda_output_file bin >> build.log 2>&1 && \
 echo 'Successful'

echo -ne "$(date +"%F-%T") - Packaging Python libraries => "
cd env/lib/python2.7/site-packages && zip -r9 $lambda_output_file * >> build.log 2>&1 && \
 echo 'Successful'
