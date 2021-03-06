using System.Collections.Generic;
using System.Linq;
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
    public ScrollingBackground scrollingBackground;

    [HideInInspector] public float timerPauseCountdown = 0f;
    private List<Animator> allWheels;

    private void Start()
    {
        Instance = this;
        currentSpeed = maxSpeed;
        allWheels = GameObject.FindGameObjectsWithTag("Wheel")
            .Select(x => x.GetComponent<Animator>()).ToList();
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
        scrollingBackground.scrollSpeed = currentSpeed;
        foreach (var wheel in allWheels)
        {
            wheel.speed = currentSpeed / maxSpeed;
        }

        int minutes = Mathf.FloorToInt(remainingSeconds / 60);
        int seconds = Mathf.FloorToInt(remainingSeconds % 60);
        timerTextUI.text = minutes + ":" + seconds.ToString("00");
    }
}