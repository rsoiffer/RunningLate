using System;
using TMPro;
using UnityEngine;

public class TrainTimer : MonoBehaviour
{
    public static TrainTimer Instance;
    
    public float remainingSeconds = 300;
    public TextMeshProUGUI timerTextUI;

    public float timerPauseCountdown = 0f;

    private void Start()
    {
        Instance = this;
    }

    private void Update()
    {
        timerPauseCountdown -= Time.deltaTime;
        if (timerPauseCountdown <= 0)
        {
            remainingSeconds -= Time.deltaTime;
        }

        int minutes = Mathf.FloorToInt(remainingSeconds / 60);
        int seconds = Mathf.FloorToInt(remainingSeconds % 60);
        timerTextUI.text = minutes + ":" + seconds.ToString("00");
    }
}