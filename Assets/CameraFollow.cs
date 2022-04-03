using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform toFollow;
    public float followRateX = 0.1f;
    public float followRateY = 0.1f;
    public float noiseX = 0.1f;
    public float noiseY = 0.1f;

    private void FixedUpdate()
    {
        transform.position = new Vector3(
            Mathf.Lerp(transform.position.x, toFollow.position.x, followRateX),
            Mathf.Lerp(transform.position.y, toFollow.position.y, followRateY),
            transform.position.z);

        transform.position += new Vector3(
            Random.Range(-1, 1) * noiseX,
            Random.Range(-1, 1) * noiseY,
            0
        );
    }
}