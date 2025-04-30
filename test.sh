shutdown_error=0 # Flag to track shutdown errors

echo "Stopping all running VMs..."
for vmid in $(qm list | awk 'NR>1 && $3=="running" {print $1}'); do
    echo "Stopping VM $vmid..."
    qm shutdown $vmid || {
        echo "Failed to stop VM $vmid, continuing..."
        shutdown_error=1
    }
done

echo "Stopping all running LXC containers..."
for ctid in $(pct list | awk 'NR>1 && $3=="running" {print $1}'); do
    echo "Stopping container $ctid..."
    pct shutdown $ctid || {
        echo "Failed to stop container $ctid, continuing..."
        shutdown_error=1
    }
done

# Add a small delay only if there was an error stopping VMs/CTs
if [ "$shutdown_error" -eq 1 ]; then
    echo "Waiting extra time due to shutdown errors..."
    sleep 15
fi
