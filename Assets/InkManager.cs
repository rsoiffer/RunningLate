using Ink.Runtime;
using TMPro;
using UnityEngine;

public class InkManager : MonoBehaviour
{
    public TextAsset inkAsset;
    public InteractableTracker interactableTracker;

    public TextMeshProUGUI nearbyTextUI;
    public Transform dialoguePanelUI;
    public TextMeshProUGUI dialogueTextUI;

    private Story inkStory;
    private string currentKnot;
    private string dialogueHistory;
    private Camera mainCamera;

    private void Start()
    {
        inkStory = new Story(inkAsset.text);
        inkStory.BindExternalFunction("nearby", (string id) => true);

        mainCamera = Camera.main;
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
                Debug.Log(inkStory.state.currentPathString);
                if (inkStory.state.currentPathString.Contains("main_loop"))
                {
                    currentKnot = null;
                    return;
                }
            }

            if (Input.GetKeyDown(KeyCode.Alpha1))
            {
                if (inkStory.currentChoices.Count >= 1)
                {
                    inkStory.ChooseChoiceIndex(0);
                    ContinueAndLogDialogue();
                }
            }

            if (Input.GetKeyDown(KeyCode.Alpha2))
            {
                if (inkStory.currentChoices.Count >= 2)
                {
                    inkStory.ChooseChoiceIndex(1);
                    ContinueAndLogDialogue();
                }
            }

            if (Input.GetKeyDown(KeyCode.Alpha3))
            {
                if (inkStory.currentChoices.Count >= 3)
                {
                    inkStory.ChooseChoiceIndex(2);
                    ContinueAndLogDialogue();
                }
            }
        }
    }

    private void UpdateText()
    {
        if (currentKnot == null)
        {
            nearbyTextUI.gameObject.SetActive(true);
            dialoguePanelUI.gameObject.SetActive(false);

            var interactable = interactableTracker.GetInteractable();
            if (interactable != null)
            {
                nearbyTextUI.text = "Press E to interact with " + interactable.inkName;
            }
            else
            {
                nearbyTextUI.text = "[no interaction available]";
            }
        }
        else
        {
            nearbyTextUI.gameObject.SetActive(false);
            dialoguePanelUI.gameObject.SetActive(true);
            dialoguePanelUI.transform.position = mainCamera.WorldToScreenPoint(
                interactableTracker.transform.position + Vector3.up);

            dialogueTextUI.text = dialogueHistory;
            if (inkStory.currentChoices.Count > 0)
            {
                for (int i = 0; i < inkStory.currentChoices.Count; ++i)
                {
                    var choice = inkStory.currentChoices[i];
                    dialogueTextUI.text += "\nChoice " + (i + 1) + ". " + choice.text;
                }
            }
        }
    }
}