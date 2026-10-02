.class public Lcom/github/tvbox/osc/shel/UpdateActivity$Receiver
.super Landroid/content/BroadcastReceiver;
.field private final a:Lcom/github/tvbox/osc/shel/UpdateActivity;

.method public constructor <init>(Lcom/github/tvbox/osc/shel/UpdateActivity;)V
    .locals 0
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V
    iput-object p1, p0, Lcom/github/tvbox/osc/shel/UpdateActivity$Receiver;->a:Lcom/github/tvbox/osc/shel/UpdateActivity;
    return-void
.end method

.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 6
    const-string v0, "extra_download_id"
    const-wide/16 v1, -0x1
    invoke-virtual {p2, v0, v1, v2}, Landroid/content/Intent;->getLongExtra(Ljava/lang/String;J)J
    move-result-wide v3
    iget-object v0, p0, Lcom/github/tvbox/osc/shel/UpdateActivity$Receiver;->a:Lcom/github/tvbox/osc/shel/UpdateActivity;
    iget-wide v1, v0, Lcom/github/tvbox/osc/shel/UpdateActivity;->downloadId:J
    cmp-long v5, v3, v1
    if-eqz v5, :go
    return-void
    :go
    const-string v1, "download"
    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v1
    check-cast v1, Landroid/app/DownloadManager;
    invoke-virtual {v1, v3, v4}, Landroid/app/DownloadManager;->getUriForDownloadedFile(J)Landroid/net/Uri;
    move-result-object v2
    if-eqz v2, :done
    new-instance v3, Landroid/content/Intent;
    const-string v4, "android.intent.action.VIEW"
    invoke-direct {v3, v4, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V
    const-string v4, "application/vnd.android.package-archive"
    invoke-virtual {v3, v4}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;
    const/high16 v4, 0x10000000
    invoke-virtual {v3, v4}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    const/4 v4, 0x1
    invoke-virtual {v3, v4}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;
    invoke-virtual {v0, v3}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V
    :done
    return-void
.end method