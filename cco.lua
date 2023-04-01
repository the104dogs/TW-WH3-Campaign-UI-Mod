//-- declarations

local m_LocalFactionName = "";
local m_ProgressBarTier = 0;                                   //-- keeps track of the current state of the progress bar

//--UI

local m_TutorialUIVisible = true;                   -- a flag for telling whether th bar is visible or not
local m_TutorialUIVisiblePriorToEndTurn = true;     -- hides the user control 
local m_TutorialUIImage = nil;                      -- reference to the progress bar image to move/resize

-- Constants

local TUTORIAL_UI_IMAGE_POSX = 10;
local TUTORIAL_UI_IMAGE_POSY = 100;

-- Constructor
function cco()

    m_LocalFactionName = cm:get_local_faction_name(true);

    InitTutorialEventListeners();
    InitTutorialUIElements();

end



--Event handlers
function OnTutorial_ProgressBar_TurnStart()

    if m_TutorialUIVisiblePriorToEndTurn then
        UpdateTTutorialUIImageVisibility(true);
    end

    if m_TutorialUIImage then
        m_TutorialUIImage.uic:MoveTo(TUTORIAL_UI_IMAGE_POSX, TUTORIAL_UI_IMAGE_POSY);
    end

end

function OnTutorialProgressBar_TurnEnd()

    if m_TutorialUIVisible then
        m_TutorialUIVisiblePriorToEndTurn = true;
        UpdateTTutorialUIImageVisibility(false);
    else
        m_TutorialUIVisiblePriorToEndTurn = false;


end







-- Functions
function InitTutorialEventListeners()

    cm:add_faction_turn_start_listener_by_name(
        "Tutorial_ProgressBar_TurnStartListener",
        m_LocalFactionName,
        OnTutorialProgressBar_TurnStart,
        true
    );

    core:add_listener(
        "Tutorial_Progressbar_TurnEndListener",
        "FactionTurnEnd",
        function(context)
            return true;
        end,
        OnTutorialProgressBar_TurnEnd,
        true
    );
end

function InitTutorialUIElements()

    local root = core:get_ui_root();
    local layout = UIComponent(root:Find("layout"));

    if layout then
        m_TutorialUIImage = AddTutorialUIImage(layout);
    end
end

function AddTutorialUIImage(parentComponent)

    local imagePath = "ui/skins/tutorial/progress_bar_tier" .. m_ProgressBarTier .. ".png";
    local imageComponent = Image.new("tutorialUIImage", parentComponent, imagePath);

    if imageComponent then
        imageComponent:Resize(90, 350);
        imageComponent.uic:MoveTo(TUTORIAL_UI_IMAGE_POSX, TUTORIAL_UI_IMAGE_POSY);
    end

    return imageComponent;

end


function UpdateTTutorialUIImageVisibility(visible)

    if m_TutorialUIImage then
        m_TutorialUIImage:SetVisible(visible);
    end
end