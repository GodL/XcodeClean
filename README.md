# XcodeClean

A command line tool which clean Xcode cache ( Using asynchronous ).

## Installation
### Option 1 (via [Mint](https://github.com/yonaskolb/Mint))
1. Install Mint via Homebrew:
```sh
brew install mint
```
or manually:
```sh
git clone https://github.com/yonaskolb/Mint.git
cd Mint
swift run mint install yonaskolb/mint
```
2. Install `XcodeClean` via Mint:
```sh
mint install GodL/XcodeClean
```
If you are receiving a permission error, try to find the command under `sudo` or refer to this [issue](https://github.com/yonaskolb/Mint/issues/188).

### Option 2 (manually)
1. Clone the repo:
```sh
git clone https://github.com/GodL/XcodeClean.git
```
2. Open the folder and build the command line tool via Swift Package Manager
```sh
swift build -c release
cd .build/release
cp -f XocdeClean /usr/local/bin/xclean
```

## Usage
Simply:
```sh
xclean
```

## Follow me on Github
I promise it's gonna be more interesting stuff there! [@GodL](https://github.com/GodL)

## License
MIT License

Copyright (c) 2020 GodL

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
