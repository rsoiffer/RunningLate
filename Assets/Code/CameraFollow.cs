using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public static CameraFollow Instance;

    public Transform toFollow;
    public float followRateX = 0.1f;
    public float followRateY = 0.1f;
    public float noiseX = 0.1f;
    public float noiseY = 0.1f;
    public float noiseRatio = 1;

    private void Start()
    {
        Instance = this;
        transform.position = new Vector3(
            toFollow.position.x,
            toFollow.position.y,
            transform.position.z
        );
    }

    private void FixedUpdate()
    {
        transform.position = new Vector3(
            Mathf.Lerp(transform.position.x, toFollow.position.x, followRateX),
            Mathf.Lerp(transform.position.y, toFollow.position.y, followRateY),
            transform.position.z);

        transform.position += noiseRatio * new Vector3(
            Random.Range(-1, 1) * noiseX,
            Random.Range(-1, 1) * noiseY,
            0
        );
    }
}