using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameStateManager : MonoBehaviour
{
    public Button startButton;
    public List<GameObject> disableOnStart;
    public List<GameObject> enableOnStart;

    private void Start()
    {
        startButton.onClick.AddListener(() =>
        {
            foreach (var o in disableOnStart)
            {
                o.SetActive(false);
            }

            foreach (var o in enableOnStart)
            {
                o.SetActive(true);
            }
        });
    }
}