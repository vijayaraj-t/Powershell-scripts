<#
This Powershell script has been made to satisfy the following requirements.
     * To quickly launch frequent apps
     * Quickly close running applications and restart your machine.

GUI is used to make it more easy to use.
 
Limitations: Its hard closing the applications so it may leave your files unsaved.Hard closing is not recomended.
-It's Done for learning Purpose only. 
#>

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

#System.Windows.Forms is used to get input.
$form=new-object System.Windows.Forms.Form
$form.Width=250
$form.Height=250
$form.Text="Quick start/stop"

#Button to quick start frequently used applications in one-click
$ButtonStart = New-Object System.Windows.Forms.Button
$ButtonStart.Location = New-Object System.Drawing.Size(75,30)
$ButtonStart.Size = New-Object System.Drawing.Size(100,40)
$ButtonStart.BackColor ="Green"
$ButtonStart.ForeColor ="White"
$ButtonStart.Text = "Start All Apps"
$ButtonStart.Add_Click({start-app})

#Button to Close all the running applications in one-click
$ButtonClose = New-Object System.Windows.Forms.Button
$ButtonClose.Location = New-Object System.Drawing.Size(75,90)
$ButtonClose.Size = New-Object System.Drawing.Size(100,40)
$ButtonClose.BackColor ="Blue"
$ButtonClose.ForeColor ="White"
$ButtonClose.Text = "Close All Apps"
$ButtonClose.Add_Click({close-app})

#Button to Close all the running applications in one-click and Restart your machine
$ButtonCloseRestart = New-Object System.Windows.Forms.Button
$ButtonCloseRestart.Location = New-Object System.Drawing.Size(75,150)
$ButtonCloseRestart.Size = New-Object System.Drawing.Size(100,40)
$ButtonCloseRestart.BackColor ="Red"
$ButtonCloseRestart.ForeColor ="White"
$ButtonCloseRestart.Text = "Close All Apps and Restart"
$ButtonCloseRestart.Add_Click({closeandrestart})

#Function to open all the applications
function start-app()
{
start-process 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe' -PassThru  #You can add more frequently used applications here for quickstart.
Start-Process notepad.exe
$form.Close()
}

#Function to close all the running applications
function close-app()
{
Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | stop-process
$form.Close()
}

#Function to close all the running applications and restart your machine
function closeandrestart()
{
Get-Process | Where-Object {$_.MainWindowTitle -ne "" -and $_.ProcessName -eq "Powershell"} | stop-process
restart-computer
}


#Controls for the form is added here
$form.Controls.Add($Buttonstart)
$form.Controls.Add($ButtonClose)
$form.Controls.Add($ButtonCloseRestart)
$form.ShowDialog()