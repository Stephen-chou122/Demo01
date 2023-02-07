% flankTest.m
%

global screens screenNumber win wsize cx cy time_stamp pixs
try
    % -------------------------sample intialize------------------------- %
    clc; clear;
    %HideCursor;
    InitializeMatlabOpenGL; % initialization
    Screen('Preference','SkipSyncTests',1); % pass test
    
    screens = Screen('Screens');
    screenNumber = max(screens); % fist screen is 0
    
    [win,wsize] = Screen('OpenWindow',screenNumber,128,[100 100 800 600]);
    cx = wsize(3)/2; cy = wsize(4)/2; % center location
    
    % --------------------------material pool-------------------------- %
    % st pool
    st = {'<<<<<','<<><<'};
    dsm = [1,2]; % st type
    repTime = 5;
    repDsm = repmat(dsm,1,repTime);
    [~,trialNum] = size(repDsm);
    finialDsm = repDsm(:,randperm(trialNum));
    % colorPool
    colorW = [255,255,255];
    % timePool
    fixOnset = 0.75;
    standOnset = 0.2;
    imgOnset = 2;
    intervalOnset = 2;
    % key down setting
    KbDown = 0;
    KbRecord = zeros(1,trialNum); % key down write
    KbACC = zeros(1,trialNum); % key down ACC
    KbRT = zeros(1,trialNum); % key down RTs
    
    % ----------------------------main code---------------------------- %
    for i = 1:5
        % fixation
        locate1 = [cx-pixs/2,cy-pixs/10,cx+pixs/2,cy+pixs/10];
        locate2 = [cx-pixs/10,cy-pixs/2,cx+pixs/10,cy+pixs/2];
        Screen('FillRect',win,128);
        Screen('FillRect',win,colorW,locate1);
        Screen('FillRect',win,colorW,locate2);
        time_stamp = Screen('Flip',win);
        
        Screen('FillRect',win,[255,255,0]);
        time_stamp = Screen('Flip',win,time_stamp+fixOnset);
        
        
        % stimuli display
        bRectSt = Screen('TextBounds',win,st{i});
        stX = cx-bRect(3)/2; stY = cy-bRect(4)/2;
        Screen('DrawText',win,st{finialDsm(i)},stX,stY,colorW);
        
        % judgement word
        % set
        KbDown = 0;
        KbName('UnifyKeyName');
        keyA = KbName('A');
        % putdown
        while ~KbDown
            [KbDown,Sec,KbCode] = KbCheck;
            startTime = GetSecs;
            if KbCode(keyA)
                resp = 1;
                break
            end
            if GetSecs-fixOnset >= imgOnset
                resp = 2;
                break
            end
        end
        
        % interval time
        Screen('FillRect',win,128);
        time_stamp = Screen('Flip',win,time_stamp+intervalOnset);
    end
    KbDown = 0;
    
    time_stamp = Screen('Flip',win,time_stamp+3);
    % close
    Screen('CloseAll');
catch
    sca;
end