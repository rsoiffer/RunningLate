using System;
using Ink.Runtime;
using UnityEngine;

public class InkApi
{
    public static InkApi Instance;

    private Story inkStory;

    public InkApi(Story inkStory)
    {
        Instance = this;
        this.inkStory = inkStory;

        inkStory.BindExternalFunction("delayTrain", (int seconds, string message) =>
        {
            Debug.Log("Need to play this message later: " + message);
            TrainTimer.Instance.timerPauseCountdown = Mathf.Max(TrainTimer.Instance.timerPauseCountdown, seconds);
        });

        inkStory.BindExternalFunction("chloroformNPC", (string npc_id) =>
            Interactable.Get(npc_id).sleepDuration = 300);

        inkStory.BindExternalFunction("changeVisualState", (string obj_id, string state_id) =>
            Interactable.Get(obj_id).SetVisualState(state_id));

        inkStory.BindExternalFunction("trainIsMoving", () =>
            TrainTimer.Instance.timerPauseCountdown <= 0f);
    }

    public string PrettyPrintInventory()
    {
        var output = (string) inkStory.EvaluateFunction("prettyPrintInventory");
        return string.Join("\n", output.Split(new[] {';'}, StringSplitOptions.RemoveEmptyEntries));
    }

    public string PrettyPrintObjectives()
    {
        var output = (string) inkStory.EvaluateFunction("prettyPrintObjectives");
        return string.Join("\n", output.Split(new[] {';'}, StringSplitOptions.RemoveEmptyEntries));
    }

    public void WakeCharacter(string npc_id)
    {
        inkStory.EvaluateFunction("characterAwakes", npc_id);
    }
}