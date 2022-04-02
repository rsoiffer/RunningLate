using UnityEngine;

public class Player : MonoBehaviour
{
    public float walkSpeed = 5.0f;
    public float walkAccel = 0.3f;
    private Rigidbody2D myRigidbody;

    private void Start()
    {
        myRigidbody = GetComponent<Rigidbody2D>();
    }

    private void FixedUpdate()
    {
        var goalMovement = Vector2.zero;
        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow))
        {
            goalMovement += Vector2.up;
        }
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow))
        {
            goalMovement += Vector2.left;
        }
        if (Input.GetKey(KeyCode.S) || Input.GetKey(KeyCode.DownArrow))
        {
            goalMovement += Vector2.down;
        }
        if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow))
        {
            goalMovement += Vector2.right;
        }

        if (goalMovement.magnitude > 1.0)
        {
            goalMovement = goalMovement.normalized;
        }

        goalMovement *= walkSpeed;
        myRigidbody.velocity = Vector2.Lerp(myRigidbody.velocity, goalMovement, walkAccel);
    }
}
