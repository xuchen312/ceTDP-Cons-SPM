function varargout = spm_ceTDP_cons(varargin)
%
% Run ceTDP-con inference
%
% =========================================================================
% FORMAT:                          spm_ceTDP_cons([xSPM,file])
%         [hReg,xSPM,SPM,TabDat] = spm_ceTDP_cons([xSPM,file])
% -------------------------------------------------------------------------
% Inputs (optional; if empty or not specified, the default is used):
%  -   xSPM: an input structure containing SPM, distribution & filtering
%            details (see spm_getSPM.m for details; default: compute xSPM
%            interactively) 
%  -   file: a character array specifying the output name for a CSV file
%            (default: output table is not saved)
%
% Outputs (optional, for interactive exploration):
%  -   hReg: handle of MIP XYZ registry object 
%            (see spm_XYZreg.m for details)
%  -   xSPM: an evaluated/thresholded structure containing SPM,
%            distribution & filtering details
%            (see spm_getSPM.m for details)
%  -    SPM: an SPM structure
%            (see spm_getSPM.m for details)
%  - TabDat: a structure containing table data with fields
%            (see spm_ceTDP_cons_list.m for details)
% =========================================================================
%

%-Set default modality
%----------------------------------------------------------------------
try
  modality = spm_get_defaults('modality');
  spm('Defaults',modality);
catch
  spm('Defaults','FMRI');
end

%-Check input arguments
%----------------------------------------------------------------------
if nargin > 2; error('Too many input arguments'); end
if nargin > 1
    if ~isempty(varargin{1})
        if isstruct(varargin{1})
            xSPM = varargin{1};
        else
            error('The 1st argument must be ''xSPM''');
        end
    end
    if ~isempty(varargin{2})
        if ischar(varargin{2})
            file = varargin{2};
        else
            error('The 2nd argument must be ''file''');
        end
    end
end
if nargin == 1
    if ~isempty(varargin{1})
        if isstruct(varargin{1})
            xSPM = varargin{1};
        elseif ischar(varargin{1})
            file = varargin{1};
        else
            error('Unrecognised input: %s', varargin{1});
        end
    end
end
if exist('file','var')
    [fpath,fname,fext] = fileparts(file);
    if isempty(fext)
        file = strcat(file,'.csv');
    elseif ~strcmpi(fext,'.csv')
        error('Unexpected output file extension: %s',fext);
    end
    if isempty(fname)
        file = fullfile(fpath,strcat('ClusTab',fext));
        warning('Found empty file name and use ''ClusTab.csv''');
    end
end

%-Query SPM and setup GUI
%----------------------------------------------------------------------
if exist('xSPM','var')
    [hReg,xSPM,SPM] = spm_ceTDP_cons_ui('Setup',xSPM);
else
    [hReg,xSPM,SPM] = spm_ceTDP_cons_ui('Setup');
end

%-Get minimum significant cluster size (from Stage 1)
%----------------------------------------------------------------------
minClusSz = spm_input('cluster-extent threshold k from Stage 1', 1, 'e', '0');
options = {'Parametric','Nonparametric'};
minClusSz_type_id = spm_input('Inference for deriving k', '+1', 'm', ...
    options, [1 2]);
minClusSz_type = options{minClusSz_type_id};

xSPM.minClusSz = minClusSz;
xSPM.minClusSz_type = minClusSz_type;

%-Compute result summary table "TabDat"
%----------------------------------------------------------------------
TabDat = spm_ceTDP_cons_list('List',xSPM,hReg);

%-Display table "TabDat"
%----------------------------------------------------------------------
%spm_ceTDP_cons_list('TxtList',TabDat);

%-Check output file name & write result table to a csv file
%----------------------------------------------------------------------
if exist('file','var')
    spm_ceTDP_cons_list('CSVList',TabDat,file);
end

%-Return outputs for interactive exploration of results in control panel
%----------------------------------------------------------------------
if nargout > 0
    varargout = {hReg,xSPM,SPM,TabDat};
end

return
