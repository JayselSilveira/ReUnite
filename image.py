import os
from argparse import Namespace
import sys
import pprint
import numpy as np
from PIL import Image
import torch
import torchvision.transforms as transforms
import matplotlib.pyplot as plt
import tkinter as tk
from tkinter import filedialog
import base64

sys.path.append(".")
sys.path.append("..")

from datasets.augmentations import AgeTransformer
from utils.common import tensor2im
from models.psp import pSp

EXPERIMENT_TYPE = 'ffhq_aging'
EXPERIMENT_DATA_ARGS = {
    "ffhq_aging": {
        "model_path": "../pretrained_models/sam_ffhq_aging.pt",
        "transform": transforms.Compose([
            transforms.Resize((256, 256)),
            transforms.ToTensor(),
            transforms.Normalize([0.5, 0.5, 0.5], [0.5, 0.5, 0.5])])
    }
}
EXPERIMENT_ARGS = EXPERIMENT_DATA_ARGS[EXPERIMENT_TYPE]
model_path = EXPERIMENT_ARGS['model_path']
ckpt = torch.load(model_path, map_location='cpu')
opts = ckpt['opts']
pprint.pprint(opts)
opts['checkpoint_path'] = model_path
opts = Namespace(**opts)
net = pSp(opts)
net.eval()
net.cuda()
print('Model successfully loaded!')


def run_alignment(image_path):
    import dlib
    from scripts.align_all_parallel import align_face
    predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")
    aligned_image = align_face(filepath=image_path, predictor=predictor)
    print("Aligned image has shape: {}".format(aligned_image.size))
    return aligned_image


def process_image(image_path, target_age):
    original_image = Image.open(image_path).convert("RGB")
    aligned_image = run_alignment(image_path)
    img_transforms = EXPERIMENT_ARGS['transform']
    input_image = img_transforms(aligned_image)
    target_ages = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    age_transformers = [AgeTransformer(target_age=age) for age in target_ages]
    results = []
    for age_transformer in age_transformers:
        print(f"Running on target age: {age_transformer.target_age}")
        with torch.no_grad():
            input_image_age = [age_transformer(input_image.cpu()).to('cuda')]
            input_image_age = torch.stack(input_image_age)
            result_tensor = run_on_batch(input_image_age, net)[0]
            result_image = tensor2im(result_tensor)
            results.append(result_image)
            if age_transformer.target_age == target_age:
                result_image_path = f"./static/Image/result_image_{target_age}.jpg"
                result_image.save(result_image_path)
                print("Result image saved at:", result_image_path)
                with open(result_image_path, 'rb') as image_file:
                    base64_image = base64.b64encode(image_file.read()).decode('utf-8')
    return result_image_path


def run_on_batch(inputs, net):
    result_batch = net(inputs.to("cuda").float(), randomize_noise=False, resize=False)
    return result_batch


def select_image():
    root = tk.Tk()
    root.withdraw()
    file_path = filedialog.askopenfilename()
    return file_path
