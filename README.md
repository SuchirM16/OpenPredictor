# OpenPredictor

## Table of Contents
*   [**About**](#about)
    * [Overview](#overview)
    * [Architectural Features](#architectural-features)
    * [Limitations and Considerations](#limitations-and-considerations)

*  [**Navigating this Repository**](#navigating-this-repository)


* [**Detailed View into the Architecture**](#detailed-view-into-the-architecture)

 
## About 

### Overview

This is an exercise at creating a hashed perceptron branch predictor based primarily on the ideas from the paper [Dynamic Branch Predicton with Perceptrons](https://www.cs.utexas.edu/~lin/papers/hpca01.pdf) by Jimenez and Lin along with a few key improvements to get it to the level of sophistication you might see in modern CPU microarchitectures.

### Architectural Features

Features that go beyond the design in the original paper include:

* **Skewed Tables** with hashing of geometric history lengths to prevent aliasing of the hashed index in the perceptron tables

* **Low Latency Adder Trees** for quick prediction computation

* **Adaptive Training Threshold** to allow the predictor to have a more accurate understanding of when to adjust weights

* **Path History Tracking** to give the predictor better accuracy and understanding of certain sequences of branches and reduce aliasing

* **Folded History Length** to optimize the trade off between the size of the design and its ability to track long branch histories

### Limitations and Considerations

A somewhat modern example of an architecture that used a hash perceptron as its main predictor was AMD's first Zen microarchitecture. I tried to build a predictor that might resemble what AMD built by thouroughly exploring various papers and mechanisms but obviously their actual implementation is a secret and it's hard to tell what might actually be going on. 

Hash Perceptron predictors are no longer considered the best design and have largely been replaced by TAGE predictors, but if recent academic papers are any indication, they are still used in many places in conjunction with TAGE, functioning as statistical correctors to create an overall more accurate hybrid predictor.

#### Limitations

This entire design has been validated only using the open source Verilator simulator. Verilator is a cycle-based simulator and cannot simulate gate or propagation delays needed for proper timing closure, nor can it be used to test the performance of a design with standard benchmarks. However, it can accurately prove logical functionality of a synchronous design like this predictor.

## Navigating this Repository

This is the folder structure for this repository
```
.
├── 📁rtl
│   ├── global_parameters.sv 
│   ├── perceptron_predictor_top.sv
│   │
│   ├── 📁history_registers
│   │   ├── global_history.sv
│   │   └── path_history.sv
│   │
│   ├── 📁perceptron_table
│   │   └── perceptron_table.sv
│   │
│   ├── 📁prediction_logic
│   │   ├── adder_tree.sv
│   │   ├── comparator.sv
│   │   └── hash_generator.sv
│   │
│   └── 📁training_logic
│       ├── condition_checker.sv
│       └── weight_updater.sv
│
├── 📁sim
│   └── 📁testbench
│       ├── 📁history_registers
│       ├── 📁perceptron_table
│       ├── 📁prediction_logic
│       └── 📁training_logic
│
├── LICENSE
└── README.md <--- You are Here
```
## Detailed View into the Architecture
