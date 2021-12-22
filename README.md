# Tesseract Training for New Fonts

This repository has the scripts for installing and training Tesseract 4+. 

### Folder Structure
The project has the following structure:
```angular2
.
|-- README.md
|-- fonts                       // This is where you place the font
|-- install_tesseract.sh        // Script for installing Tesseract
|-- ouput                       // Checkpoints and model saved here
|-- train                       // Training Data is placed here
`-- training.sh                 // Script for Training Tesseract

```
### System Configurations
- Instance type   : `t2.large` 
- Storage         : `40GB`
- Operating System: `Ubuntu 18`

### Steps for Running the Project

1. Run `./install_tesseract.sh`
2. Place the font in the `fonts` folder
3. Run `./training.sh`

### Tuning Parameters
Two paramters that can be tuned to increase the performance of the model are:
1. `MAX_PAGES`: This is the number of pages generated for training the model.
2. `NUM_ITERATIONS`: This is the number of times the fine tuning process will happen.

The paramters are available in the `training.sh file`

### Useful Link
- https://tesseract-ocr.github.io/tessdoc/Compiling
- https://medium.com/quantrium-tech/installing-tesseract-4-on-ubuntu-18-04-b6fcd0cbd78f
- https://tesseract-ocr.github.io/tessdoc/Data-Files-in-tessdata_fast
- https://github.com/dhivehi/tesseractfonts
- https://github.com/tesseract-ocr/langdata_lstm


# Training process
The training process has 3 main stages as shown in the diagram below:

-------------         -------------         ------------
Generate Training Data ------> Fine Tune Existing Model ------> Combine Model
-------------         -------------         ------------

### Generating Training Data
The first step in the training process is to generate the training data. In our case, we will use tesstrain.sh script provided by tesseract to generate the training data.
```angular2
tesstrain.sh --fonts_dir fonts 
             --fontlist "Jokerman Regular" 
             --lang eng 
             --linedata_only 
             --langdata_dir ./tesseract/langdata_lstm 
             --tessdata_dir ./tesseract/tessdata  
             --maxpages 10 
             --output_dir train
```
The above code will create training data and add it to the /train folder. The name of the font is passed in the fontlist parameter. maxpages defines the number of pages of data generated.

### Fine Tuning Tuning Existing Model
We are training a model that can detect Jokerman font. So we could take the best English model and fine-tune it to fit the font. Extract the model from eng.traineddata and use it to fine-tune the font.
```angular2
combine_tessdata -e ./tesseract/tessdata/eng.traineddata eng.lstm

OMP_THREAD_LIMIT=8 lstmtraining 
    --continue_from eng.lstm 
    --model_output output/jokerman 
    --traineddata tesseract/tessdata/eng.traineddata
    --train_listfile ./train/eng.training_files.txt
    --max_iterations 400
```
### Combine Model
Once the fine-tuned model is obtained, combine the generated checkpoints with the best English model to get the final jokerman.trainneddata
```angular2
lstmtraining --stop_training
             --continue_from output/jokerman_checkpoint
             --traineddata ./tesseract/tessdata/eng.traineddata
             --model_output output/jokerman.traineddata
```
### References
- https://github.com/tesseract-ocr/
- https://github.com/tesseract-ocr/tesseract/wiki/TrainingTesseract-4.00
- https://www.linkedin.com/pulse/custom-font-training-tesseract-nikhil-baby
