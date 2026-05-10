# EEG-Attention-Analysis-Dashboard
Interactive MATLAB dashboard for EEG-based attention and cognitive state analysis using spectral biomarkers and visualization.


# EEG Attention Analysis Dashboard

Interactive MATLAB dashboard for EEG-based attention and cognitive state analysis using spectral biomarkers and real-time visualization.

---

## Overview

This project is an interactive neurotechnology dashboard developed in MATLAB for analyzing EEG datasets and estimating cognitive attention states.

The system processes EEG recordings, extracts frequency-domain biomarkers, and generates an overall attention score using neural signal characteristics associated with focus, engagement, and drowsiness.

The dashboard provides:
- Real-time style attention scoring
- EEG power spectrum visualization
- Biomarker extraction
- Cognitive state classification
- Interactive GUI interface



## Features
- Interactive MATLAB GUI interface
- EEG dataset loading (.mat format)
- Attention scoring system
- Spectral power analysis
- Theta/Alpha ratio analysis
- Beta/Theta ratio analysis
- Spectral entropy calculation
- Engagement index computation
  

## BIOMARKERS AND METRICS USED (see def'n below):

    ### Theta / Alpha Ratio
    Associated with:
    - cognitive fatigue
    - drowsiness
    - reduced attentional control
    
    ### Beta / Theta Ratio
    Associated with:
    - active concentration
    - executive attention
    - engagement
    
    ### Engagement Index
    Computed using beta relative to alpha and theta activity.
    
    ### Spectral Entropy
    Measures EEG signal complexity and neural variability.
    
    ## Dashboard Components
    
    ### Live Attention Gauge
    Displays:
    - overall attention score
    - cognitive state classification
    
    ### EEG Power Spectrum
    Displays:
    - EEG spectral activity from 1–40 Hz
    - highlighted theta, alpha, and beta bands
    
    ### Biomarker Panel
    Displays extracted biomarker values including:
    - frontal theta
    - posterior alpha
    - beta/theta ratio
    - engagement index
    - spectral entropy




## HOW TO RUN

1. Open MATLAB
2. Open the project folder
3. Run:
'''matlab
EEG_AttentionDashboard
'''
4. Click: "Load EEG Dataset"
5. Select a compatible EEG `.mat` dataset.



## Dataset Requirements

The dashboard expects MATLAB .mat files containing an EEGLAB-style EEG structure:

```matlab
EEG.data
EEG.srate
EEG.chanlocs
```

## Tools and software Used

- MATLAB
- Signal Processing
- FFT-based spectral analysis
- EEGLAB-compatible EEG structures
- Interactive GUI development


## Example Applications

- Neurotechnology research
- Attention tracking
- Cognitive workload analysis
- Brain-computer interface prototyping
- Fatigue monitoring
- Biomedical signal processing education


## Future Improvements and Extensions

Potential future additions:
- Real-time EEG streaming
- Brain topography maps
- Multitask cognitive analysis
- Session recording




## Author
Developed by Griffin Anderson
Biomedical Engineering — Vanderbilt University
