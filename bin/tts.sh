#!/bin/bash

TTSCMD="festival --pipe --tts"
xsel | $TTSCMD | mpv
