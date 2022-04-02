using UnityEngine;

public class ScrollingBackground : MonoBehaviour
{
    public float scrollSpeed = 5f;
    public float jumpDistance = 10f;

    private void Update()
    {
        transform.position += scrollSpeed * Time.deltaTime * Vector3.left;
        if (transform.position.x < -jumpDistance)
        {
            transform.position += 2 * jumpDistance * Vector3.right;
        }
    }
}