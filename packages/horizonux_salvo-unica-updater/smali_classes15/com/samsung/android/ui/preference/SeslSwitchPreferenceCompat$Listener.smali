.class Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat$Listener;
.super Ljava/lang/Object;
.source "SeslSwitchPreferenceCompat.java"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "Listener"
.end annotation


# instance fields
.field final synthetic this$0:Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat;


# direct methods
.method private constructor <init>(Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat;)V
    .locals 0

    .line 128
    iput-object p1, p0, Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat$Listener;->this$0:Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat;Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat$1;)V
    .locals 0
    .param p1, "x0"    # Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat;
    .param p2, "x1"    # Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat$1;

    .line 128
    invoke-direct {p0, p1}, Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat$Listener;-><init>(Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat;)V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 2
    .param p1, "buttonView"    # Landroid/widget/CompoundButton;
    .param p2, "isChecked"    # Z

    .line 131
    iget-object v0, p0, Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat$Listener;->this$0:Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat;

    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat;->callChangeListener(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 132
    xor-int/lit8 v0, p2, 0x1

    invoke-virtual {p1, v0}, Landroid/widget/CompoundButton;->setChecked(Z)V

    .line 133
    return-void

    .line 136
    :cond_0
    iget-object v0, p0, Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat$Listener;->this$0:Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat;

    invoke-virtual {v0, p2}, Lcom/samsung/android/ui/preference/SeslSwitchPreferenceCompat;->setChecked(Z)V

    .line 137
    return-void
.end method
