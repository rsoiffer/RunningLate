using UnityEngine;

public class SpawnScenery : MonoBehaviour
{
    public GameObject spawnPrefab;
    public int numToSpawn;
    public Vector2 spawnArea;

    private void Start()
    {
        for (int i = 0; i < numToSpawn; i++)
        {
            var newPos = new Vector3(
                Random.Range(-spawnArea.x, spawnArea.x),
                Random.Range(-spawnArea.y, spawnArea.y),
                0);
            var newSpawn = Instantiate(spawnPrefab, transform);
            newSpawn.transform.position += newPos;
        }
    }
}