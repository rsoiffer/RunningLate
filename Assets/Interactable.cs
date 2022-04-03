using System;
using System.Collections.Generic;
using UnityEngine;

public class Interactable : MonoBehaviour
{
    private static Dictionary<string, Interactable> allInteractables = new Dictionary<string, Interactable>();

    public static Interactable Get(string name) => allInteractables[name];

    [HideInInspector] public string visualState;
    [HideInInspector] public float sleepDuration;

    private void OnEnable()
    {
        if (allInteractables.ContainsKey(name))
        {
            Debug.LogError("Duplicate ink name: " + name);
            return;
        }

        allInteractables.Add(name, this);
        SetVisualState(transform.GetChild(0).name);
    }

    private void OnDisable()
    {
        allInteractables.Remove(name);
    }

    public void SetVisualState(string newState)
    {
        visualState = newState;
        GetComponent<Collider2D>().enabled = !newState.Contains("_nointeract");
        foreach (Transform child in transform)
        {
            child.gameObject.SetActive(child.name == newState);
        }
    }

    private void Update()
    {
        var oldSleepDuration = sleepDuration;
        sleepDuration -= Time.deltaTime;
        if (sleepDuration <= 0 && oldSleepDuration > 0)
        {
            InkApi.Instance.WakeCharacter(name);
        }
    }
}