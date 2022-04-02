using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform toFollow;
    public float followRate = 0.1f;

    private void FixedUpdate()
    {
        var newPosition = Vector2.Lerp(transform.position, toFollow.position, followRate);
        transform.position = new Vector3(newPosition.x, newPosition.y, transform.position.z);
    }
}