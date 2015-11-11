public enum ContainerEvent: String {
    case PlaybackStateChanged = "clappr:container:playback_state_changed"
    case PlaybackStateDVRStateChanged = "clappr:container:playback_dvr_state_changed"
    case BitRate = "clappr:container:bit_rate"
    case Destroyed = "clappr:container:destroyed"
    case Ready = "clappr:container:ready"
    case Error = "clappr:container:error"
    case LoadedMetadata = "clappr:container:loaded_metadata"
    case TimeUpdated = "clappr:container:time_update"
    case Progress = "clappr:container:progress"
    case Play = "clappr:container:play"
    case Stop = "clappr:container:stop"
    case Pause = "clappr:container:pause"
    case Ended = "clappr:container:ended"
    case Tap = "clappr:container:tap"
    case Seek = "clappr:container:seek"
    case Volume = "clappr:container:volume"
    case Fullscreen = "clappr:container:fullscreen"
    case Buffering = "clappr:container:buffering"
    case BufferFull = "clappr:container:buffer_full"
    case SettingsUpdated = "clappr:container:settings_updated"
    case HighDefinitionUpdated = "clappr:container:hd_updated"
    case MediaControlDisabled = "clappr:container:media_control_disabled"
    case MediaControlEnabled = "clappr:container:media_control_enabled"
}