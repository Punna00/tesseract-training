# Update the machine
sudo apt-get update

# Install training dependencies
sudo apt-get install libicu-dev libpango1.0-dev libcairo2-dev -y
sudo apt install libtesseract-dev -y
sudo apt-get install libleptonica-dev -y


# Clone tesseract repo
git clone https://github.com/tesseract-ocr/tesseract.git --branch 4.0 --single-branch

# Install tesseract
cd tesseract/
./autogen.sh
./configure
make
sudo make install
sudo ldconfig
make training
sudo make training-install

# Add path to .bashrc
echo  'export TESSDATA_PREFIX=/usr/local/share/tessdata' >> ~/.bashrc
source ~/.bashrc

# Testing tesseract installation
echo `tesseract --version | grep 'tesseract'`

# Download langdata_lstm
git clone https://github.com/tesseract-ocr/langdata_lstm.git

#Download the best english trained data to tessdata
cd ./tessdata/
wget https://github.com/tesseract-ocr/tessdata_best/raw/master/eng.traineddata




