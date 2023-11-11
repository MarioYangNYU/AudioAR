using UnityEngine;

public class RotationSetter : MonoBehaviour
{
    public Transform obj1; // assign this in inspector or by script
    public Transform obj3; // assign this in inspector or by script

    void Loop()
    {
        // Get the world rotation of obj1
        Quaternion worldRotationOfObj1 = obj1.rotation;

        // Set this rotation to obj3
        obj3.rotation = worldRotationOfObj1;
    }
}
