/*
    Copyright © 2020, Luna Nielsen
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/
module engine.audio.astream.ogg;
import engine.audio.astream;
import vorbisfile;
import std.string;
import engine.core.log;
import std.exception;
import std.typecons;

/**
    An Ogg Vorbis audio stream
*/
class OggStream : AudioStream {
private:
    string fname;
    OggVorbis_File file;
    int section;
    int word;
    int signed;

    int bitrate_;


    void verifyError(int error) {
        switch(error) {
            case OV_EREAD: throw new Exception("A read from media returned an error");
            case OV_ENOTVORBIS: throw new Exception("File is not a valid ogg vorbis file");
            case OV_EVERSION: throw new Exception("Vorbis version mismatch");
            case OV_EBADHEADER: throw new Exception("Bad OGG Vorbis header");
            case OV_EFAULT: throw new Exception("OGG Vorbis bug or stack corruption");
            default: break;
        }
    }

public:

    /**
        Deallocates on deconstruction
    */
    ~this() {
        ov_clear(&file);
    }

    /**
        Opens the OGG Vorbis stream file
    */
    this(string file, bool bit16) {
        this.fname = file;

        // Open the file and verify it opened correctly
        int error = ov_fopen(file.toStringz, &this.file);
        this.verifyError(error);

        // Get info about file
        auto info = ov_info(&this.file, -1);
        enforce(info.channels <= 2, "Too many channels in OGG Vorbis file");

        this.bitrate_ = info.rate;

        // Set info about this file
        this.channels = info.channels;
        if (this.channels == 1) {
            this.format = bit16 ? Format.Mono16 : Format.Mono8;
        } else {
            this.format = bit16 ? Format.Stereo16 : Format.Stereo8;
        }
        word = format == Format.Stereo8 || format == Format.Mono8 ? 1 : 2;
        signed = format == Format.Mono16 || format == Format.Stereo16 ? 1 : 0;
    }

    ptrdiff_t iReadSamples(ref ubyte[] toArray, size_t readLength) {

        // Read a verify the success of the read
        ptrdiff_t readAmount = cast(ptrdiff_t)ov_read(&file, cast(byte*)toArray.ptr, cast(int)readLength, 0, word, signed, &section);
        assert(readAmount >= 0, "An error occured trying to read from the ogg vorbis stream");
        return readAmount;
    }

override:
    ptrdiff_t readSamples(ref ubyte[] toArray) {
        ubyte[] tmpBuf = new ubyte[4096];
        ptrdiff_t buffOffset;
        ptrdiff_t buffLength;
        do {
            buffLength = iReadSamples(tmpBuf, toArray.length-buffOffset);
            toArray[buffOffset..buffOffset+buffLength] = tmpBuf[0..buffLength];
            buffOffset += buffLength; 
        } while(buffOffset < toArray.length && buffLength > 0);
        return buffOffset;
    }

    /**
        Gets whether the file can be seeked
    */
    bool canSeek() {
        return cast(bool)ov_seekable(&file);
    }

    /**
        Seek to a PCM location in the stream
    */
    void seek(size_t location) {
        ov_pcm_seek(&file, location);
    }

    /**
        Get the position in the stream
    */
    size_t tell() {
        return ov_pcm_tell(&file);
    }

    /**
        Gets the bitrate
    */
    size_t bitrate() {
        return bitrate_;
    }

    /**
        Gets info about the OGG audio

        Only music usually uses this
    */
    AudioInfo getInfo() {
        
        // Inline function to get the ogg comments as a D string array
        string[] getOggInfo() {
            string[] fields;

            // Iterate over every comment
            foreach(i; 0..file.vc.comments) {
                immutable(int) commentLength = file.vc.comment_lengths[i];
                string comment = cast(string)file.vc.user_comments[i][0..commentLength];
                fields ~= comment;
            }
            return fields;
        }

        // Parse ogg info as a array of key and value
        string[2] parseOggInfo(string info) {
            auto idx = info.indexOf("=");
            enforce(idx >= 0, "Invalid info");
            return [info[0..idx], info[idx+1..$]];
        }

        // Inline function to parse the ogg info
        string[string] parseOggInfos() {
            string[string] infos;

            string[] fields = getOggInfo();
            foreach(i, field; fields) {
                try {
                    string[2] info = parseOggInfo(field);
                    infos[info[0]] = info[1];
                } catch (Exception ex) {
                    AppLog.warn("Ogg Subsystem", "Failed the parse comment field %s: %s! Got data %s", i, ex.msg, field);
                }
            }

            return infos;
        }

        AudioInfo info;
        string[string] kv = parseOggInfos();
        info.file = this.fname;
        if ("ARTIST" in kv) info.artist = kv["ARTIST"];
        if ("TITLE" in kv) info.title = kv["TITLE"];
        if ("ALBUM" in kv) info.album = kv["ALBUM"];
        if ("PERFOMER" in kv) info.performer = kv["PERFOMER"];
        if ("DATE" in kv) info.date = kv["DATE"];
        return info;
    }
}