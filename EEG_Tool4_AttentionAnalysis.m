function EEG_AttentionDashboard()

% =========================================================
% EEG ATTENTION ANALYSIS SUITE
%
% INTERACTIVE BIOMEDICAL DASHBOARD
%
% Features:
% - EEG dataset loading
% - Attention scoring
% - Live semicircular gauge
% - PSD visualization
% - Biomarker analysis
% - Dynamic status indicators
% - Modern dark UI
%
% Compatible with EEGLAB EEG structs
% =========================================================

clc;
close all;

%% ========================================================
% MAIN FIGURE
% =========================================================
fig = uifigure(...
    'Name','EEG Attention Analysis Suite',...
    'Color',[0.08 0.08 0.10],...
    'Position',[50 30 1550 950]);

%% ========================================================
% TITLE
% =========================================================
uilabel(fig,...
    'Text','EEG ATTENTION ANALYSIS SUITE',...
    'FontSize',28,...
    'FontWeight','bold',...
    'FontColor','white',...
    'Position',[500 800 600 40]);

%% ========================================================
% LOAD BUTTON
% =========================================================
btnLoad = uibutton(fig,...
    'push',...
    'Text','Load EEG Dataset',...
    'FontSize',16,...
    'Position',[40 790 200 45]);

%% ========================================================
% SAVE BUTTON
% =========================================================
btnSave = uibutton(fig,...
    'push',...
    'Text','Save Results',...
    'FontSize',16,...
    'Position',[260 790 180 45]);

%% ========================================================
% ATTENTION SCORE PANEL
% =========================================================
scorePanel = uipanel(fig,...
    'Title','Live Attention State',...
    'FontSize',20,...
    'BackgroundColor',[0.12 0.12 0.15],...
    'ForegroundColor','white',...
    'Position',[20 390 420 370]);

%% MAIN GAUGE
scoreGauge = uigauge(scorePanel,'semicircular');

scoreGauge.Position = [30 20 350 240];

scoreGauge.Limits = [0 100];

scoreGauge.Value = 0;

%% Yellow -> Green scale
scoreGauge.ScaleColors = [
    1 1 0
    0.4 1 0
    0 1 0
];

scoreGauge.ScaleColorLimits = [
    0 40
    40 70
    70 100
];

scoreGauge.FontColor = 'white';

scoreGauge.BackgroundColor = [0.12 0.12 0.15];

%% Attention State Text
attentionText = uilabel(scorePanel,...
    'Text','Waiting for EEG Data...',...
    'FontSize',24,...
    'FontWeight','bold',...
    'FontColor','white',...
    'HorizontalAlignment','center',...
    'Position',[20 290 360 35]);

%% Large Score Number
scoreNumber = uilabel(scorePanel,...
    'Text','0',...
    'FontSize',48,...
    'FontWeight','bold',...
    'FontColor','white',...
    'HorizontalAlignment','center',...
    'Position',[130 220 120 50]);

%% ========================================================
% BIOMARKER PANEL
% =========================================================
bioPanel = uipanel(fig,...
    'Title','Biomarkers',...
    'FontSize',20,...
    'BackgroundColor',[0.12 0.12 0.15],...
    'ForegroundColor','white',...
    'Position',[20 30 420 330]);

txtBio = uitextarea(bioPanel,...
    'Position',[15 15 385 270],...
    'FontSize',16,...
    'Editable','off',...
    'BackgroundColor',[0.08 0.08 0.10],...
    'FontColor','white');

%% ========================================================
% PSD AXES
% =========================================================
axPSD = uiaxes(fig,...
    'Position',[470 400 1020 360]);

axPSD.Color = [0.10 0.10 0.12];

axPSD.GridColor = [0.4 0.4 0.4];

axPSD.MinorGridColor = [0.3 0.3 0.3];

axPSD.XColor = 'white';

axPSD.YColor = 'white';

axPSD.Box = 'on';

title(axPSD,'EEG Power Spectrum',...
    'Color','white',...
    'FontSize',18,...
    'FontWeight','bold');

xlabel(axPSD,'Frequency (Hz)',...
    'Color','white',...
    'FontSize',14);

ylabel(axPSD,'Power (dB)',...
    'Color','white',...
    'FontSize',14);

grid(axPSD,'on');

%% ========================================================
% BAR GRAPH AXES
% =========================================================
axBar = uiaxes(fig,...
    'Position',[470 40 1020 300]);

axBar.Color = [0.10 0.10 0.12];

axBar.GridColor = [0.4 0.4 0.4];

axBar.XColor = 'white';

axBar.YColor = 'white';

axBar.Box = 'on';

title(axBar,'Attention Biomarkers',...
    'Color','white',...
    'FontSize',18,...
    'FontWeight','bold');

grid(axBar,'on');

%% ========================================================
% STORAGE VARIABLE
% =========================================================
results = [];

%% ========================================================
% BUTTON CALLBACKS
% =========================================================
btnLoad.ButtonPushedFcn = @(btn,event) loadEEG();

btnSave.ButtonPushedFcn = @(btn,event) saveResults();

%% ========================================================
% LOAD EEG FUNCTION
% =========================================================
function loadEEG()

    %% FILE SELECT
    [file,path] = uigetfile('*.mat','Select EEG Dataset');

    if isequal(file,0)
        return;
    end

    filename = fullfile(path,file);

    %% Loading Animation
    attentionText.Text = 'Loading EEG Dataset...';

    drawnow;

    pause(0.5);

    %% LOAD FILE
    S = load(filename);

    if ~isfield(S,'EEG')

        uialert(fig,...
            'Selected MAT file does not contain EEG struct.',...
            'Invalid File');

        return;
    end

    EEG = S.EEG;

    signal = double(EEG.data);

    fs = EEG.srate;

    labels = {EEG.chanlocs.labels};

    [nCh,~] = size(signal);

    %% REMOVE DC OFFSET
    signal = signal - mean(signal,2);

    %% FFT PSD
    x = signal';

    n = size(x,1);

    nfft = 2^nextpow2(n);

    X = fft(x,nfft,1);

    P2 = (abs(X)/n).^2;

    pxx = P2(1:nfft/2+1,:);

    pxx(2:end-1,:) = 2*pxx(2:end-1,:);

    f = fs*(0:(nfft/2))'/nfft;

    %% FREQUENCY BANDS
    theta_idx = (f>=4)&(f<=8);

    alpha_idx = (f>=8)&(f<=12);

    beta_idx = (f>=13)&(f<=30);

    theta_power = mean(pxx(theta_idx,:),1);

    alpha_power = mean(pxx(alpha_idx,:),1);

    beta_power = mean(pxx(beta_idx,:),1);

    %% CHANNEL REGIONS
    frontal_names = {'Fz','F3','F4','Fp1','Fp2','FCz'};

    posterior_names = {'O1','O2','Oz','Pz','P3','P4','POz'};

    frontal_idx = find(ismember(labels, frontal_names));

    posterior_idx = find(ismember(labels, posterior_names));

    %% AUTO CHANNEL DETECTION
    if isempty(frontal_idx) || isempty(posterior_idx)

        chanlocs = EEG.chanlocs;

        Y = nan(1,length(chanlocs));

        for k = 1:length(chanlocs)

            if isfield(chanlocs(k),'Y')

                yk = chanlocs(k).Y;

                if ischar(yk) || isstring(yk)
                    yk = str2double(yk);
                end

                Y(k) = yk;

            end
        end

        valid = ~isnan(Y);

        validIdx = find(valid);

        [~,sortIdx] = sort(Y(valid),'ascend');

        kN = max(5, round(0.10 * sum(valid)));

        posterior_idx = validIdx(sortIdx(1:kN));

        frontal_idx = validIdx(sortIdx(end-kN+1:end));

    end

    %% BIOMARKERS
    frontal_theta = mean(theta_power(frontal_idx));

    frontal_beta = mean(beta_power(frontal_idx));

    posterior_alpha = mean(alpha_power(posterior_idx));

    theta_alpha_ratio = frontal_theta / posterior_alpha;

    beta_theta_ratio = frontal_beta / frontal_theta;

    engagement_index = ...
        mean(beta_power) / ...
        (mean(alpha_power) + mean(theta_power));

    %% SPECTRAL ENTROPY
    entropy_band = (f>=1)&(f<=40);

    pxx_entropy = pxx(entropy_band,:);

    nFreq = size(pxx_entropy,1);

    spectral_entropy = zeros(1,nCh);

    for ch = 1:nCh

        psd = pxx_entropy(:,ch);

        psd_norm = psd/(sum(psd)+eps);

        H = -sum(psd_norm .* log2(psd_norm+eps));

        spectral_entropy(ch) = H/log2(nFreq);

    end

    global_entropy = mean(spectral_entropy);

    %% ATTENTION SCORE
    beta_theta_score = ...
        min(max(beta_theta_ratio/3,0),1);

    theta_alpha_score = ...
        1 - min(max(theta_alpha_ratio/2,0),1);

    entropy_score = ...
        1 - abs(global_entropy - 0.65);

    engagement_score = ...
        min(max(engagement_index/1.5,0),1);

    attention_score = ...
          0.35 * beta_theta_score ...
        + 0.30 * theta_alpha_score ...
        + 0.20 * engagement_score ...
        + 0.15 * entropy_score;

    attention_score = attention_score * 100;

    %% CLASSIFICATION
    if attention_score >= 75

        attention_state = 'Highly Focused';

        statusLamp.Color = [0 1 0];

        attentionText.FontColor = [0 1 0];

        scoreNumber.FontColor = [0 1 0];

    elseif attention_score >= 55

        attention_state = 'Moderately Attentive';

        statusLamp.Color = [0.7 1 0];

        attentionText.FontColor = [0.7 1 0];

        scoreNumber.FontColor = [0.7 1 0];

    else

        attention_state = 'Distracted / Drowsy';

        statusLamp.Color = [1 1 0];

        attentionText.FontColor = [1 1 0];

        scoreNumber.FontColor = [1 1 0];

    end

    %% UPDATE MAIN DISPLAY
    scoreGauge.Value = attention_score;

    attentionText.Text = attention_state;

    scoreNumber.Text = sprintf('%.0f',attention_score);

    %% BIOMARKER TEXT
    biomarkerText = sprintf([ ...
        'Frontal Theta: %.5f\n\n' ...
        'Posterior Alpha: %.5f\n\n' ...
        'Frontal Beta: %.5f\n\n' ...
        'Theta/Alpha Ratio: %.4f\n\n' ...
        'Beta/Theta Ratio: %.4f\n\n' ...
        'Engagement Index: %.4f\n\n' ...
        'Spectral Entropy: %.4f'], ...
        frontal_theta, ...
        posterior_alpha, ...
        frontal_beta, ...
        theta_alpha_ratio, ...
        beta_theta_ratio, ...
        engagement_index, ...
        global_entropy);

    txtBio.Value = biomarkerText;

    %% ========================================================
    % CLEAN PSD PLOT
    %% ========================================================
    cla(axPSD);

    avgPSD = mean(pxx,2);

    validFreq = f >= 1 & f <= 40;

    f_plot = f(validFreq);

    psd_plot = avgPSD(validFreq);

    psd_dB = 10 * log10(psd_plot + eps);

    plot(axPSD,...
        f_plot,...
        psd_dB,...
        'LineWidth',2,...
        'Color',[1 0.4 0]);

    hold(axPSD,'on');

    axPSD.XLim = [1 40];

    yMin = floor(min(psd_dB));

    yMax = ceil(max(psd_dB));

    axPSD.YLim = [yMin yMax];

    %% EEG BAND OVERLAYS

    % Theta
    patch(axPSD,...
        [4 8 8 4],...
        [yMin yMin yMax yMax],...
        [0.2 0.2 1],...
        'FaceAlpha',0.08,...
        'EdgeColor','none');

    % Alpha
    patch(axPSD,...
        [8 12 12 8],...
        [yMin yMin yMax yMax],...
        [0 1 0],...
        'FaceAlpha',0.08,...
        'EdgeColor','none');

    % Beta
    patch(axPSD,...
        [13 30 30 13],...
        [yMin yMin yMax yMax],...
        [1 0.5 0],...
        'FaceAlpha',0.06,...
        'EdgeColor','none');

    %% Replot PSD on top
    plot(axPSD,...
        f_plot,...
        psd_dB,...
        'LineWidth',2,...
        'Color',[1 0.4 0]);

    hold(axPSD,'off');

    %% ========================================================
    % BAR GRAPH
    %% ========================================================
    cla(axBar);

    vals = [
        theta_alpha_ratio
        beta_theta_ratio
        engagement_index
        global_entropy
    ];

    b = bar(axBar,vals);

    b.FaceColor = [0 0.5 1];

    axBar.XTickLabel = {
        'Theta/Alpha'
        'Beta/Theta'
        'Engagement'
        'Entropy'
    };

    %% STORE RESULTS
    results = struct;

    results.filename = filename;

    results.attention_score = attention_score;

    results.attention_state = attention_state;

    results.frontal_theta = frontal_theta;

    results.posterior_alpha = posterior_alpha;

    results.frontal_beta = frontal_beta;

    results.theta_alpha_ratio = theta_alpha_ratio;

    results.beta_theta_ratio = beta_theta_ratio;

    results.engagement_index = engagement_index;

    results.global_entropy = global_entropy;

end

%% ========================================================
% SAVE RESULTS FUNCTION
% ========================================================
function saveResults()

    if isempty(results)

        uialert(fig,...
            'No results available.',...
            'Nothing to Save');

        return;

    end

    [file,path] = uiputfile('*.mat','Save Results');

    if isequal(file,0)
        return;
    end

    save(fullfile(path,file),'results');

    uialert(fig,...
        'Results saved successfully.',...
        'Saved');

end

end