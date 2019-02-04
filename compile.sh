docker run --mount type=bind,source=/mnt/output,target=/output -it 3ceb0a281f8e 7.2.502.24 arm.release arm arm-linux-androideabi-4.9 arm-linux-androideabi
docker run --mount type=bind,source=/mnt/output,target=/output -it 3ceb0a281f8e 7.2.502.24 x64.release x64 x86_64-4.9 x86_64-linux-android
docker run -it 3ceb0a281f8e 7.2.502.24 x86.release x86 x86-4.9 i686-linux-android
