param([string]$ProjectDir)
$ErrorActionPreference = 'Stop'
$activity = 'com.github.tvbox.osc.shel.UpdateActivity'
$manifest = Join-Path $ProjectDir 'AndroidManifest.xml'
$appSmali = Get-ChildItem -Path $ProjectDir -Recurse -Filter 'app.smali' | Where-Object { $_.FullName -match 'com[\\/]github[\\/]tvbox[\\/]osc[\\/]shel[\\/]app\.smali$' } | Select-Object -First 1
if (-not $appSmali) { throw '找不到 com.github.tvbox.osc.shel.app.smali，无法安全注入启动检查。' }

$xml = Get-Content -Raw -LiteralPath $manifest
if ($xml -notmatch [regex]::Escape($activity)) {
  $line = '        <activity android:enabled="true" android:exported="false" android:launchMode="singleTop" android:name="com.github.tvbox.osc.shel.UpdateActivity" android:theme="@android:style/Theme.DeviceDefault.Light.Dialog.Alert" />'
  $pattern = '(?m)(\s*<activity\s+android:enabled="true"\s+android:exported="true"[^>]*android:name="com\.github\.tvbox\.osc\.ui\.activity\.HomeActivity"[^>]*/?>)'
  if ($xml -notmatch $pattern) { throw '找不到 HomeActivity，无法安全插入 UpdateActivity。' }
  $xml = [regex]::Replace($xml, $pattern, ($line + "`r`n" + '$1'), 1)
  Set-Content -LiteralPath $manifest -Value $xml -Encoding UTF8
}

$s = Get-Content -Raw -LiteralPath $appSmali.FullName
if ($s -notmatch 'Lcom/github/tvbox/osc/shel/UpdateActivity;') {
  $method = @'

.method public onCreate()V
    .locals 3
    invoke-super {p0}, Lcom/dex2c/shell/ShellApplication;->onCreate()V
    new-instance v0, Landroid/content/Intent;
    const-class v1, Lcom/github/tvbox/osc/shel/UpdateActivity;
    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V
    const/high16 v1, 0x10000000
    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    invoke-virtual {p0, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    return-void
.end method
'@
  Add-Content -LiteralPath $appSmali.FullName -Value $method -Encoding UTF8
}
