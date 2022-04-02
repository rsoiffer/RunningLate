using System.Collections.Generic;
using UnityEngine;

public class InteractableTracker : MonoBehaviour
{
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

    public Interactable GetInteractable()
    {
        return interactables.Count > 0 ? interactables[0] : null;
    }
}