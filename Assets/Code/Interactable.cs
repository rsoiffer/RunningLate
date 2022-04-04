using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;

public class Interactable : MonoBehaviour
{
    private static Dictionary<string, Interactable> allInteractables = new Dictionary<string, Interactable>();

    public static Interactable Get(string name) => allInteractables[name];

    public Transform worldCanvas;
    public GameObject timerPanelPrefab;
    private GameObject myTimerPanel;
    private TextMeshProUGUI myTimerText;

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
        sleepDuration -= Time.deltaTime;

        if (sleepDuration > 0)
        {
            if (myTimerPanel == null)
            {
                myTimerPanel = Instantiate(timerPanelPrefab, worldCanvas);
                myTimerPanel.transform.position += transform.position;
                myTimerText = myTimerPanel.GetComponentsInChildren<TextMeshProUGUI>()
                    .First(c => c.name == "Timer Text");
            }

            int minutes = Mathf.FloorToInt(sleepDuration / 60);
            int seconds = Mathf.FloorToInt(sleepDuration % 60);
            myTimerText.text = minutes + ":" + seconds.ToString("00");
        }
        else if (myTimerPanel != null)
        {
            Destroy(myTimerPanel);
            InkApi.Instance.WakeCharacter(name);
        }
    }
}