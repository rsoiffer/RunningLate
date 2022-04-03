using System.Collections.Generic;
using Ink.Runtime;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class InkManager : MonoBehaviour
{
    public TextAsset inkAsset;
    public InteractableTracker interactableTracker;
    public Transform dialogueLayout;
    public TextMeshProUGUI dialogueTextUI;
    public Button dialogueButtonPrefab;

    private Story inkStory;
    private string currentKnot;
    private string dialogueHistory;
    private List<Button> dialogueButtons = new List<Button>();
    private int nextChoice = -1;

    private void Start()
    {
        inkStory = new Story(inkAsset.text);
        inkStory.BindExternalFunction("nearby", (string obj_id) => true);
        inkStory.BindExternalFunction("addTime", (string timer_id, string seconds) => true);
    }

    private void Update()
    {
        StepInk();
        UpdateText();
    }

    private void ContinueAndLogDialogue()
    {
        inkStory.Continue();
        if (dialogueHistory.Length > 0)
        {
            dialogueHistory += "\n";
        }

        dialogueHistory += inkStory.currentText;

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

            var buttonText = button.GetComponentInChildren<Text>();
            buttonText.text = "(" + choiceIndex + ") " + inkStory.currentChoices[i].text;
        }
    }

    private void StepInk()
    {
        if (currentKnot == null)
        {
            var interactable = interactableTracker.GetInteractable();
            if (interactable != null)
            {
                if (Input.GetKeyDown(KeyCode.E))
                {
                    inkStory.ChoosePathString(interactable.inkName);
                    currentKnot = interactable.inkName;
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
                if (Input.GetKeyDown(KeyCode.Space))
                {
                    ContinueAndLogDialogue();
                }
            }

            if (inkStory.canContinue)
            {
                if (inkStory.state.currentPathString.Contains("main_loop"))
                {
                    currentKnot = null;
                    return;
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
    }

    private void UpdateText()
    {
        if (currentKnot == null)
        {
            var interactable = interactableTracker.GetInteractable();
            if (interactable != null)
            {
                dialogueTextUI.text = "Press E to interact with " + interactable.inkName;
            }
            else
            {
                dialogueTextUI.text = "";
            }
        }
        else
        {
            dialogueTextUI.text = dialogueHistory;
        }
    }
}