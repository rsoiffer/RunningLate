using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class InteractableTracker : MonoBehaviour
{
    public TextMeshProUGUI interactionText;
    private List<Interactable> interactables = new List<Interactable>();

    private void OnTriggerEnter2D(Collider2D col)
    {
        var interactable = col.GetComponentInParent<Interactable>();
        if (interactable != null)
        {
            interactables.Add(interactable);
        }
    }

    private void OnTriggerExit2D(Collider2D col)
    {
        var interactable = col.GetComponentInParent<Interactable>();
        if (interactable != null)
        {
            interactables.Remove(interactable);
        }
    }

    private void Update()
    {
        interactionText.text = "";
        if (interactables.Count > 0)
        {
            var interactable = interactables[0];
            interactionText.text = interactable.interactMessage;
        }
    }
}