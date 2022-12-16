#pull branch
openpose_ros2_branch="main"

# clone or pull openpose_ros2
if [ -d ./openpose_ros2 ]; then
    echo "[openpose_ros2] is already cloned."

    while :
    do
        read -p "Update [openpose_ros2？(Y/n)" pull_ans

        if [ "$pull_ans" = "Y" -o "$pull_ans" = "y" ]; then
            cd openpose_ros2
            git pull origin $openpose_ros2_branch
            cd ../

            echo "[openpose_ros2] is updated!"
            echo ""
            break
        elif [ "$pull_ans" = "N" -o "$pull_ans" = "n" ]; then
            echo "Did not update [openpose_ros2]."
            echo ""
            break
        else
            echo "Input Y or n key"
            echo ""
        fi
    done

else
    git clone -b $openpose_ros2_branch git@github.com:Rits-Interaction-Laboratory/openpose_ros2.git

    echo "[openpose_ros2]'s clone is complete!"
    echo ""
fi
