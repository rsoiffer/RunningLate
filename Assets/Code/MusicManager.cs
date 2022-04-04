using UnityEngine;
using UnityEngine.UI;

public class MusicManager : MonoBehaviour
{
    public Button muteButton;
    public Button unmuteButton;

    private AudioSource audioSource;

    private void Start()
    {
        audioSource = GetComponent<AudioSource>();
        muteButton.onClick.AddListener(() =>
        {
            audioSource.volume = 0;
            muteButton.gameObject.SetActive(false);
            unmuteButton.gameObject.SetActive(true);
        });
        unmuteButton.onClick.AddListener(() =>
        {
            audioSource.volume = 1;
            unmuteButton.gameObject.SetActive(false);
            muteButton.gameObject.SetActive(true);
        });
    }
}