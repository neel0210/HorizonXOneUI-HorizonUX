.class Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState$1;
.super Ljava/lang/Object;
.source "SeslPreference.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 996
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState;
    .locals 1
    .param p1, "var1"    # Landroid/os/Parcel;

    .line 998
    new-instance v0, Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState;

    invoke-direct {v0, p1}, Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState;-><init>(Landroid/os/Parcel;)V

    return-object v0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 996
    invoke-virtual {p0, p1}, Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState$1;->createFromParcel(Landroid/os/Parcel;)Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState;

    move-result-object p1

    return-object p1
.end method

.method public newArray(I)[Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState;
    .locals 1
    .param p1, "var1"    # I

    .line 1002
    new-array v0, p1, [Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState;

    return-object v0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 996
    invoke-virtual {p0, p1}, Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState$1;->newArray(I)[Lcom/samsung/android/ui/preference/SeslPreference$BaseSavedState;

    move-result-object p1

    return-object p1
.end method
