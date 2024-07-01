# Task 1:
 * TaskYour company has employed many new developers. As a SysOps engineer, write a bash script called create_users.sh that reads a text file containing the employee’s usernames and group names, where each line is formatted as user;groups.The script should create users and groups as specified, set up home directories with appropriate permissions and ownership, generate random passwords for the users, and log all actions to /var/log/user_management.log. Additionally, store the generated passwords securely in /var/secure/user_passwords.txt.Ensure error handling for scenarios like existing users and provide clear documentation and comments within the script.

Kindly run the file with the sudo command
i.e sudo ./create_users.sh <name-of-text-file>
