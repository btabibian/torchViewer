# Torch Viewer
This repository provides simple infrastructure to interact with torch outputs produced by a Neaural Network model. 
It can be used for visualizing neaural network models and input data. 
Also it can be used to export data to other programming languages with an HTTP interface.

This library uses [Turbo](https://github.com/kernelsauce/turbo) library for underlying communication infrastructure.

Usage
====

To use the library you start the server as follows:
```
th main.lua -file_format lm_model_mdl_sample_btch.00_loss.t7 -input_dir ../../path/to/files
```
where ```mdl```, ```iter``` and ```loss``` are replacement for values in file names in the input directoy. 
The pattern can match file names like ```lm_model_100_sample_32.00_0.003608.t7```. where:

+ ```mdl``` is the placement for model name
+ ```btch``` is the placement for iteration count.
+ ```loss``` is the placement for error loss in that iteration.

---
### File Format
A torch file is currently assumed to have following format:
```
--table of batches
{
1 : 
  { -- table of values for each batch 
  x: Tensor(AxB)
  y: Tensor(AxC)
  pred: Tensor(AxD)
}
2: { -- table of values for each batch 
  x: Tensor(AxB)
  y: Tensor(AxC)
  pred: Tensor(AxD)
}
...
}
```

---
### HTTP Interface

There are two handlers implemented so far:
```
http://127.0.0.1:8888/model/[ModelName] -- returns the current number of iterations and list of indecies into iterations.
```
and:
```
http://127.0.0.1:8888/model/[ModelName]/[iteration] -- returns information about a particular iteration.
http://127.0.0.1:8888/model/[ModelName]/[iteration]?batch=N&ind=I -- return values x,y,pred of a particular record in a particular batch.
```
