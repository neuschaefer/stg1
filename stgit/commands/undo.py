from stgit.argparse import opt
from stgit.commands.common import CmdException, DirectoryHasRepository
from stgit.lib import log, transaction

__copyright__ = """
Copyright (C) 2008, Karl Hasselström <kha@treskal.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License version 2 as
published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see http://www.gnu.org/licenses/.
"""

help = 'Undo the last operation'
kind = 'stack'
usage = ['']
description = """
Reset the patch stack to the previous state. Consecutive invocations
of "stg undo" will take you ever further into the past."""

args = []
options = [
    opt(
        '-n',
        '--number',
        type='int',
        metavar='N',
        default=1,
        short='Undo the last N commands',
    ),
    opt(
        '--hard',
        action='store_true',
        short='Discard changes in your index/worktree',
    ),
]

directory = DirectoryHasRepository()


def func(parser, options, args):
    stack = directory.repository.current_stack
    if options.number < 1:
        raise CmdException('Bad number of commands to undo')
    state = log.undo_state(stack, options.number)
    trans = transaction.StackTransaction(stack, discard_changes=options.hard)
    try:
        log.reset_stack(trans, stack.repository.default_iw, state)
    except transaction.TransactionHalted:
        pass
    return trans.execute(
        'undo %d' % options.number, stack.repository.default_iw, allow_bad_head=True
    )
