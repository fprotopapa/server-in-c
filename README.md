# C Project Template with Criterion

## Installing Criterion

```
git clone --recursive https://github.com/Snaipe/Criterion
cd Criterion
meson --prefix=/usr build
sudo ninja -C build install

# Or
sudo apt-get install libcriterion-dev
```
## Run

```
# Debug Build
make
# Run Tests
make test
# Release Build
make DEBUG=0
# Clean Release or Debug Build
make clean
# Remove all
make clean_all
```