

How to build:

```
git clone https://github.com/AMReX-Codes/amrex.git

cmake -S amrex -B amrex/build \
	-G "Visual Studio 16 2019" -A x64 \
	-DAMReX_FORTRAN=OFF \
	-DAMReX_GPU_BACKEND=CUDA \
	-DCMAKE_CXX_STANDARD=17 \
	-DCMAKE_CUDA_STANDARD=17 \
	-DAMReX_CUDA_ARCH=6.0 \

cmake --build amrex/build --config Release

git clone https://github.com/robertmaynard/amrex_tutorial.git

cmake -S amrex_tutorial -B amrex_tutorial/build/ \
	-G "Visual Studio 16 2019" -A x64 \
	-DCMAKE_PREFIX_PATH=$(path)/amrex/build

cmake --build amrex_tutorial/build --config Release
```
