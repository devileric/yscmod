.class public Lcom/github/tvbox/osc/shel/UpdateActivity
.super Landroid/app/Activity;
.implements Landroid/content/DialogInterface$OnClickListener;
.implements Ljava/lang/Runnable;
.source "UpdateActivity.java"

.field private apkUrl:Ljava/lang/String;
.field private forceUpdate:Z
.field private versionName:Ljava/lang/String;
.field private updateLog:Ljava/lang/String;
.field private downloadId:J
.field private runningOnUi:Z

.method public constructor <init>()V
    .locals 2
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    const-wide/16 v0, -0x1
    iput-wide v0, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->downloadId:J
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
    const/4 v0, 0x0
    iput-boolean v0, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->runningOnUi:Z
    new-instance v0, Ljava/lang/Thread;
    invoke-direct {v0, p0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V
    return-void
.end method

.method public run()V
    .locals 15
    iget-boolean v0, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->runningOnUi:Z
    if-eqz v0, :cond_fetch
    invoke-direct {p0}, Lcom/github/tvbox/osc/shel/UpdateActivity;->showUpdate()V
    return-void
    :cond_fetch
    const/4 v0, 0x0
    :try_start
    new-instance v1, Ljava/net/URL;
    const-string v2, "https://4351.kstore.space/update/update.json"
    invoke-direct {v1, v2}, Ljava/net/URL;-><init>(Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v1
    check-cast v1, Ljava/net/HttpURLConnection;
    const/16 v2, 0x2710
    invoke-virtual {v1, v2}, Ljava/net/URLConnection;->setConnectTimeout(I)V
    invoke-virtual {v1, v2}, Ljava/net/URLConnection;->setReadTimeout(I)V
    const-string v2, "GET"
    invoke-virtual {v1, v2}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v2
    const/16 v3, 0xc8
    if-ne v2, v3, :cond_done
    new-instance v2, Ljava/io/BufferedReader;
    new-instance v3, Ljava/io/InputStreamReader;
    invoke-virtual {v1}, Ljava/net/URLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v4
    const-string v5, "UTF-8"
    invoke-direct {v3, v4, v5}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
    invoke-direct {v2, v3}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v3, Ljava/lang/StringBuilder;
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
    :read_loop
    invoke-virtual {v2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v4
    if-nez v4, :append
    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V
    new-instance v2, Lorg/json/JSONObject;
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-direct {v2, v3}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    const-string v3, "versionCode"
    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I
    move-result v3
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v4
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v5
    const/4 v6, 0x0
    invoke-virtual {v4, v5, v6}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    move-result-object v4
    iget v4, v4, Landroid/content/pm/PackageInfo;->versionCode:I
    if-le v3, v4, :cond_done
    const-string v3, "versionName"
    const-string v4, ""
    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    iput-object v3, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->versionName:Ljava/lang/String;
    const-string v3, "apkUrl"
    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    iput-object v3, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->apkUrl:Ljava/lang/String;
    const-string v3, "updateLog"
    const-string v4, "发现新版本"
    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3
    iput-object v3, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->updateLog:Ljava/lang/String;
    const-string v3, "forceUpdate"
    const/4 v4, 0x0
    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z
    move-result v2
    iput-boolean v2, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->forceUpdate:Z
    const/4 v0, 0x1
    :cond_done
    if-eqz v1, :after_conn
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V
    :after_conn
    if-eqz v0, :finish
    const/4 v1, 0x1
    iput-boolean v1, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->runningOnUi:Z
    invoke-virtual {p0, p0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    return-void
    :append
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop
    :finish
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch
    :catch
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
.end method

.method private showUpdate()V
    .locals 5
    new-instance v0, Landroid/app/AlertDialog$Builder;
    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    const-string v1, "发现新版本"
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    new-instance v1, Ljava/lang/StringBuilder;
    const-string v2, "版本 "
    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    iget-object v2, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->versionName:Ljava/lang/String;
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v2, "\n\n"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    iget-object v2, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->updateLog:Ljava/lang/String;
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    const-string v1, "立即更新"
    invoke-virtual {v0, v1, p0}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    iget-boolean v1, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->forceUpdate:Z
    if-nez v1, :show
    const-string v1, "以后再说"
    invoke-virtual {v0, v1, p0}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    :show
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    return-void
.end method

.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 4
    const/4 v0, -0x1
    if-eq p2, v0, :download
    iget-boolean v0, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->forceUpdate:Z
    if-eqz v0, :close
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
    :download
    new-instance v0, Landroid/app/DownloadManager$Request;
    iget-object v1, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->apkUrl:Ljava/lang/String;
    invoke-static {v1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;
    move-result-object v1
    invoke-direct {v0, v1}, Landroid/app/DownloadManager$Request;-><init>(Landroid/net/Uri;)V
    const-string v1, "应用更新"
    invoke-virtual {v0, v1}, Landroid/app/DownloadManager$Request;->setTitle(Ljava/lang/CharSequence;)Landroid/app/DownloadManager$Request;
    const-string v1, "正在下载新版本"
    invoke-virtual {v0, v1}, Landroid/app/DownloadManager$Request;->setDescription(Ljava/lang/CharSequence;)Landroid/app/DownloadManager$Request;
    const-string v1, "application/vnd.android.package-archive"
    invoke-virtual {v0, v1}, Landroid/app/DownloadManager$Request;->setMimeType(Ljava/lang/String;)Landroid/app/DownloadManager$Request;
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/app/DownloadManager$Request;->setNotificationVisibility(I)Landroid/app/DownloadManager$Request;
    invoke-virtual {v0, v1}, Landroid/app/DownloadManager$Request;->setAllowedOverMetered(Z)Landroid/app/DownloadManager$Request;
    const-string v1, "update.apk"
    invoke-virtual {v0, v1}, Landroid/app/DownloadManager$Request;->setDestinationInExternalFilesDir(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Landroid/app/DownloadManager$Request;
    const-string v1, "download"
    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/app/DownloadManager;
    invoke-virtual {v1, v0}, Landroid/app/DownloadManager;->enqueue(Landroid/app/DownloadManager$Request;)J
    move-result-wide v2
    iput-wide v2, p0, Lcom/github/tvbox/osc/shel/UpdateActivity;->downloadId:J
    new-instance v0, Lcom/github/tvbox/osc/shel/UpdateActivity$Receiver;
    invoke-direct {v0, p0}, Lcom/github/tvbox/osc/shel/UpdateActivity$Receiver;-><init>(Lcom/github/tvbox/osc/shel/UpdateActivity;)V
    new-instance v2, Landroid/content/IntentFilter;
    const-string v3, "android.intent.action.DOWNLOAD_COMPLETE"
    invoke-direct {v2, v3}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V
    invoke-virtual {p0, v0, v2}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
    :close
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V
    invoke-virtual {p0}, Landroid/app/Activity;->finish()V
    return-void
.end method