import reaper

type
  Project* = object
    reaperPtr*: ReaProject

  Track* = object
    reaperPtr*: MediaTrack

  Item* = object
    reaperPtr*: MediaItem

converter toPtr*(project: Project): ReaProject = project.reaperPtr
converter toPtr*(track: Track): MediaTrack = track.reaperPtr
converter toPtr*(item: Item): MediaItem = item.reaperPtr