.class Lcom/mesalabs/cerberus/ui/preference/LayoutPreference$3;
.super Ljava/lang/Object;
.source "LayoutPreference.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/mesalabs/cerberus/ui/preference/LayoutPreference;-><init>(Landroid/content/Context;Landroid/view/View;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/mesalabs/cerberus/ui/preference/LayoutPreference;


# direct methods
.method constructor <init>(Lcom/mesalabs/cerberus/ui/preference/LayoutPreference;)V
    .locals 0
    .param p1, "this$0"    # Lcom/mesalabs/cerberus/ui/preference/LayoutPreference;

    .line 76
    iput-object p1, p0, Lcom/mesalabs/cerberus/ui/preference/LayoutPreference$3;->this$0:Lcom/mesalabs/cerberus/ui/preference/LayoutPreference;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/view/View;)V
    .locals 1
    .param p1, "view"    # Landroid/view/View;

    .line 78
    iget-object v0, p0, Lcom/mesalabs/cerberus/ui/preference/LayoutPreference$3;->this$0:Lcom/mesalabs/cerberus/ui/preference/LayoutPreference;

    invoke-static {v0, p1}, Lcom/mesalabs/cerberus/ui/preference/LayoutPreference;->access$200(Lcom/mesalabs/cerberus/ui/preference/LayoutPreference;Landroid/view/View;)V

    .line 79
    return-void
.end method
