.class Lcom/samsung/android/ui/preference/EditTextPreference$SavedState$1;
.super Ljava/lang/Object;
.source "EditTextPreference.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/samsung/android/ui/preference/EditTextPreference$SavedState;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/samsung/android/ui/preference/EditTextPreference$SavedState;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 124
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/samsung/android/ui/preference/EditTextPreference$SavedState;
    .locals 1
    .param p1, "in"    # Landroid/os/Parcel;

    .line 127
    new-instance v0, Lcom/samsung/android/ui/preference/EditTextPreference$SavedState;

    invoke-direct {v0, p1}, Lcom/samsung/android/ui/preference/EditTextPreference$SavedState;-><init>(Landroid/os/Parcel;)V

    return-object v0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 124
    invoke-virtual {p0, p1}, Lcom/samsung/android/ui/preference/EditTextPreference$SavedState$1;->createFromParcel(Landroid/os/Parcel;)Lcom/samsung/android/ui/preference/EditTextPreference$SavedState;

    move-result-object p1

    return-object p1
.end method

.method public newArray(I)[Lcom/samsung/android/ui/preference/EditTextPreference$SavedState;
    .locals 1
    .param p1, "size"    # I

    .line 132
    new-array v0, p1, [Lcom/samsung/android/ui/preference/EditTextPreference$SavedState;

    return-object v0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 124
    invoke-virtual {p0, p1}, Lcom/samsung/android/ui/preference/EditTextPreference$SavedState$1;->newArray(I)[Lcom/samsung/android/ui/preference/EditTextPreference$SavedState;

    move-result-object p1

    return-object p1
.end method