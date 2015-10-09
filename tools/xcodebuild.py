# -*- coding: utf-8 -*-
import subprocess
import sys
from optparse import OptionParser


def option():
    parser = OptionParser()
    parser.add_option(
        "-a",
        "--archive",
        action="store",
        type="string",
        dest="archivePath",
        help="path of archive"
    )

    parser.add_option(
        "-f",
        "--file",
        action="store",
        type="string",
        dest="file",
        help="ipa file name"
    )

    parser.add_option(
        "-p",
        "--profile",
        action="store",
        type="string",
        dest="profileName",
        help="Ureserve or Resebook or Resty"
    )

    return parser.parse_args()


def doBuildCmd(args):
    cmd = "xcodebuild -exportArchive -archivePath " + args.archivePath + " -exportPath ~/Desctop/Ipa/" + args.file + " -exportFormat ipa -exportProvisioningProfile " + args.profileName
    print("/****** cmd")
    print(cmd)
    print("/****** cmd")

    res = subprocess.check_output(cmd.split(" "))
    print(res)


if __name__ == "__main__":
    argvs = sys.argv
    opt, arg = option()
    doBuildCmd(opt)
