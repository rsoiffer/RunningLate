using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class TrainTimer : MonoBehaviour
{
    public static TrainTimer Instance;

    public float remainingSeconds = 300;
    public TextMeshProUGUI timerTextUI;

    public float maxSpeed = 50;
    private float currentSpeed;
    public float trainAccel = 5;
    public List<ScrollingBackground> scrollingBackgrounds;

    [HideInInspector] public float timerPauseCountdown = 0f;

    private void Start()
    {
        Instance = this;
        currentSpeed = maxSpeed;
    }

    private void Update()
    {
        timerPauseCountdown -= Time.deltaTime;
        if (timerPauseCountdown <= 0)
        {
            remainingSeconds -= Time.deltaTime;
            remainingSeconds = Mathf.Max(remainingSeconds, 0);
        }

        var goalSpeed = timerPauseCountdown <= 0 ? maxSpeed : 0f;
        var deltaSpeed = trainAccel * Time.deltaTime;
        currentSpeed = Mathf.Clamp(goalSpeed, currentSpeed - deltaSpeed, currentSpeed + deltaSpeed);
        CameraFollow.Instance.noiseRatio = currentSpeed / maxSpeed;
        foreach (var scrollingBackground in scrollingBackgrounds)
        {
            scrollingBackground.scrollSpeed = currentSpeed;
        }

        int minutes = Mathf.FloorToInt(remainingSeconds / 60);
        int seconds = Mathf.FloorToInt(remainingSeconds % 60);
        timerTextUI.text = minutes + ":" + seconds.ToString("00");
    }
}