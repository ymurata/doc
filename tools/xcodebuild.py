# -*- coding: utf-8 -*-
import subprocess
import sys
import argparse


def option():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-t",
        "--type",
        type=str,
        action="store",
        required=True,
        help="Ureserve"
    )
    parser.add_argument(
        "-p",
        "--path",
        type=str,
        action="store",
        required=True,
        help="archive path"
    )

    return parser.parse_args()


def doBuildCmd(opts):
    cmd = "xcodebuild -exportArchive -archivePath " + "\ ".join(opts.path.split(" ")) + " -exportPath ~/Desktop/Ipa/" + opts.type + "/" + opts.type + " -exportFormat ipa -exportProvisioningProfile " + opts.type
    print("/****** cmd")
    print(opts)
    print(cmd)
    print("/****** cmd")

    res = subprocess.check_output(cmd.split(" "))
    print(res)


if __name__ == "__main__":
    argvs = sys.argv
    opts = option()
    doBuildCmd(opts)
