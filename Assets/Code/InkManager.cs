using System.Collections.Generic;
using Ink.Runtime;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class InkManager : MonoBehaviour
{
    public TextAsset inkAsset;
    public InteractableTracker interactableTracker;
    public Button dialogueButtonPrefab;
    public float minContinueTime = 0.5f;
    public float timeToAutoContinue = 5f;
    public Button bottomPanelButton;

    public GameObject objectivesPanel;
    public TextMeshProUGUI objectivesTextUI;
    public TextMeshProUGUI inventoryTextUI;

    public GameObject interactPanel;
    public TextMeshProUGUI interactTextUI;

    public GameObject dialoguePanel;
    public Transform dialogueLayout;
    public TextMeshProUGUI dialogueTextUI;

    private Story inkStory;
    private InkApi inkApi;

    private string currentKnot;
    private string dialogueHistory;
    private List<Button> dialogueButtons = new List<Button>();
    private int nextChoice = -1;
    private float currentTimeToAutoContinue;
    private bool interactInput;
    private float interactInputCooldown;

    private void Start()
    {
        inkStory = new Story(inkAsset.text);
        inkApi = new InkApi(inkStory);
        bottomPanelButton.onClick.AddListener(() => interactInput = true);
    }

    private void Update()
    {
        interactInput = interactInput || Input.GetKeyDown(KeyCode.Space) || Input.GetKeyDown(KeyCode.E);
        interactInputCooldown -= Time.deltaTime;
        if (interactInputCooldown > 0)
        {
            interactInput = false;
        }

        currentTimeToAutoContinue -= Time.deltaTime;
        StepInk();
        UpdateText();
        interactInput = false;
    }

    private string ParseText(string text)
    {
        var textSplits = text.Split(':');
        if (textSplits.Length == 2)
        {
            if (textSplits[0] == "You")
            {
                return "<b><color=#8a8e48>" + textSplits[0] + "</color></b>  <color=#debf89>" + textSplits[1] +
                       "</color>";
            }

            return "<b><color=#a45f3e>" + textSplits[0] + "</color></b>  <color=#debf89>" + textSplits[1] + "</color>";
        }

        return "<color=#debf89>" + text + "</color>";
    }

    private void ContinueAndLogDialogue()
    {
        currentTimeToAutoContinue = timeToAutoContinue;
        if (inkStory.canContinue)
        {
            inkStory.Continue();
            var text = inkStory.currentText.Trim('\r', '\n', ' ');
            if (text.Length > 0)
            {
                dialogueHistory += "\n" + ParseText(text);
            }
        }

        UpdateDialogueButtons();
    }

    private void UpdateDialogueButtons()
    {
        foreach (var button in dialogueButtons)
        {
            Destroy(button.gameObject);
        }

        dialogueButtons.Clear();

        for (int i = 0; i < inkStory.currentChoices.Count; i++)
        {
            var button = Instantiate(dialogueButtonPrefab, dialogueLayout);
            dialogueButtons.Add(button);

            var choiceIndex = i + 1;
            button.onClick.AddListener(() => nextChoice = choiceIndex);

            var buttonText = button.GetComponentInChildren<TextMeshProUGUI>();
            buttonText.text = "<color=#debf89>(" + choiceIndex + ")</color> " +
                              ParseText(inkStory.currentChoices[i].text);
        }
    }

    private void StepInk()
    {
        if (TrainTimer.Instance != null && TrainTimer.Instance.remainingSeconds == 0f && currentKnot != "game_over")
        {
            inkStory.ChoosePathString("game_over");
            currentKnot = "game_over";
            dialogueHistory = "";
            ContinueAndLogDialogue();
        }

        if (currentKnot == null)
        {
            var interactable = interactableTracker.GetInteractable();
            if (interactable != null)
            {
                if (interactInput)
                {
                    interactInput = false;
                    interactInputCooldown = minContinueTime;
                    inkStory.ChoosePathString(interactable.name);
                    currentKnot = interactable.name;
                    dialogueHistory = "";
                    ContinueAndLogDialogue();
                    StepInk();
                }
            }
        }
        else
        {
            if (inkStory.canContinue)
            {
                if (interactInput || currentTimeToAutoContinue < 0)
                {
                    interactInput = false;
                    interactInputCooldown = minContinueTime;
                    ContinueAndLogDialogue();
                }
            }

            if (Input.GetKeyDown(KeyCode.Alpha1))
            {
                nextChoice = 1;
            }

            if (Input.GetKeyDown(KeyCode.Alpha2))
            {
                nextChoice = 2;
            }

            if (Input.GetKeyDown(KeyCode.Alpha3))
            {
                nextChoice = 3;
            }

            if (Input.GetKeyDown(KeyCode.Alpha4))
            {
                nextChoice = 4;
            }

            if (Input.GetKeyDown(KeyCode.Alpha5))
            {
                nextChoice = 5;
            }

            if (nextChoice > 0 && inkStory.currentChoices.Count >= nextChoice)
            {
                inkStory.ChooseChoiceIndex(nextChoice - 1);
                nextChoice = 0;
                ContinueAndLogDialogue();
            }
        }

        if (inkStory.canContinue && inkStory.state.currentPathString.Contains("main_loop")
            || inkStory.currentChoices.Count > 0 && inkStory.currentChoices[0].text.Contains("INTERACT"))
        {
            currentKnot = null;
        }
    }

    private void UpdateText()
    {
        if (currentKnot == null)
        {
            var interactable = interactableTracker.GetInteractable();
            if (interactable != null)
            {
                objectivesPanel.SetActive(false);
                dialoguePanel.SetActive(false);
                interactPanel.SetActive(true);
                interactTextUI.text = "Press E to interact with " + interactable.name;
            }
            else
            {
                objectivesPanel.SetActive(true);
                dialoguePanel.SetActive(false);
                interactPanel.SetActive(false);
                objectivesTextUI.text = "<b>Objectives</b>\n" + inkApi.PrettyPrintObjectives();
                inventoryTextUI.text = "<b>Inventory</b>\n" + inkApi.PrettyPrintInventory();
            }
        }
        else
        {
            objectivesPanel.SetActive(false);
            dialoguePanel.SetActive(true);
            interactPanel.SetActive(false);
            dialogueTextUI.text = dialogueHistory;
        }
    }
}